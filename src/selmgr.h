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

#pragma once

#include <X11/Xlib.h>
#include <X11/Xatom.h>

#include <chrono>
#include <cstdint>
#include <functional>
#include <string>
#include <unordered_map>
#include <vector>

namespace zutty
{
   class SelectionManager
   {
   public:
      SelectionManager (Display*, Window);

      Atom getPrimary () const { return primary; };
      Atom getClipboard () const { return clipboard; };

      using PasteCallbackFn = std::function <void (bool, const std::string&)>;
      void getSelection (Atom selection, const Time, PasteCallbackFn&&);
      bool setSelection (Atom selection, const Time, const std::string&);
      bool copySelection (Atom dest, Atom source, const Time);

      void onPropertyNotify (XPropertyEvent& event);
      void onSelectionClear (XSelectionClearEvent& event);
      void onSelectionNotify (XSelectionEvent& event);
      void onSelectionRequest (XSelectionRequestEvent& event);

      // Milliseconds until the next ongoing transfer times out, or -1 if
      // there is none (suitable as the timeout argument of poll ())
      int getTimeout () const;
      // Abort ongoing transfers whose peer has not responded in time
      void checkTimeouts ();

   private:
      using Clock = std::chrono::steady_clock;

      // Same as the default selectionTimeout of the X Toolkit
      constexpr const static int Timeout_Ms = 5000;

      Display* dpy;
      Window win;

      const Atom primary;
      const Atom clipboard;

      const Atom incr;
      const Atom prop;
      const Atom target;
      const Atom targets;
      const Atom timestamp;
      const size_t chunkSize;

      enum class State: uint8_t
      {
         Idle,
         WaitingForIncrAck,
         WaitingForSelNotify,
         ReadingIncr
      };

      struct Context
      {
         Time acquired = 0;
         std::string content;
         PasteCallbackFn pasteCallback;
         State state = State::Idle;
         Clock::time_point deadline; // if state is not Idle

         // inbound transfer state
         std::vector <unsigned char> incoming;

         // outbound transfer state
         size_t cliPos;
         Window cliWin;
         Atom cliProp;
         Atom cliTarget;
      };
      std::unordered_map <Atom, Context> ctx;

      std::string atomName (Atom atom) const;
      void setDeadline (Context& cx);
      void handleInboundIncr (Context& cx);
      void handleOutboundIncr (Context& cx);
   };

} // namespace zutty
