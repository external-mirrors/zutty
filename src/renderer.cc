/* This file is part of Zutty.
 * Copyright (C) 2020 Tom Szilagyi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * See the file LICENSE for the full license.
 */

#include "renderer.h"

#include <cassert>

namespace zutty
{
   Renderer::Renderer (const std::function <void ()>& initDisplay,
                       const std::function <void ()>& swapBuffers_,
                       Fontpack* fontpk)
      : swapBuffers {swapBuffers_}
      , thr (&Renderer::renderThread, this, initDisplay, fontpk)
   {
   }

   Renderer::~Renderer ()
   {
      std::unique_lock <std::mutex> lk (mx);
      done = true;
      nextFrame.seqNo = ++seqNo;
      lk.unlock ();
      cond.notify_all ();
      thr.join ();
   }

   void
   Renderer::update (const Frame& frame)
   {
      std::unique_lock <std::mutex> lk (mx);
      nextFrame = frame;
      nextFrame.seqNo = ++seqNo;
      lk.unlock ();
      cond.notify_all ();
   }

   void
   Renderer::lockFrame ()
   {
      std::unique_lock <std::mutex> lk (mx);
      // N.B.: let a waiting render thread have its turn first, so it does
      // not starve while we are processing a continuous stream of input.
      cond.wait (lk, [&] () { return !frameCopying && !frameWanted; });
      frameLocked = true;
   }

   void
   Renderer::unlockFrame ()
   {
      std::unique_lock <std::mutex> lk (mx);
      frameLocked = false;
      lk.unlock ();
      cond.notify_all ();
   }

   void
   Renderer::renderThread (const std::function <void ()>& initDisplay,
                           Fontpack* fontpk)
   {
      initDisplay ();

      charVdev = std::make_unique <CharVdev> (fontpk);

      Frame lastFrame;
      bool delta = false;

      while (1)
      {
         std::unique_lock <std::mutex> lk (mx);
         cond.wait (lk,
                    [&] ()
                    {
                       return lastFrame.seqNo != nextFrame.seqNo;
                    });

         if (done)
            return;

         const uint16_t winPx = nextFrame.winPx;
         const uint16_t winPy = nextFrame.winPy;
         lk.unlock ();

         // N.B.: resizing and mapping might wait for the GPU, so do them
         // before we would hold up the frame lock.
         if (charVdev->resize (winPx, winPy))
            delta = false;

         Rect selection;
         {
            CharVdev::Mapping m = charVdev->getMapping ();

            lk.lock ();
            frameWanted = true;
            cond.wait (lk, [&] () { return done || !frameLocked; });
            frameWanted = false;

            if (done)
               return;

            if (nextFrame.winPx != winPx || nextFrame.winPy != winPy)
            {
               // resized in the meantime, start over with the new size
               lk.unlock ();
               cond.notify_all ();
               delta = false;
               continue;
            }

            if (lastFrame.seqNo + 1 != nextFrame.seqNo)
               delta = false;

            lastFrame = nextFrame;
            frameCopying = true;
            lk.unlock ();

            assert (m.nCols == lastFrame.nCols);
            assert (m.nRows == lastFrame.nRows);

            if (delta)
               lastFrame.deltaCopyCells (m.cells);
            else
               lastFrame.fullCopyCells (m.cells);

            selection = lastFrame.getSnappedSelection ();

            lk.lock ();
            frameCopying = false;
            lk.unlock ();
            cond.notify_all ();
         }

         charVdev->setDeltaFrame (delta);
         charVdev->setCursor (lastFrame.getCursor ());
         charVdev->setSelection (selection);

         lk.lock ();
         const bool outdated = lastFrame.seqNo != nextFrame.seqNo;
         lk.unlock ();

         if (!outdated)
         {
            charVdev->draw ();
            swapBuffers ();
            delta = true;
         }
         else
         {
            // skip drawing outdated frame; force full redraw next time
            delta = false;
         }
      }
   }

} // namespace zutty
