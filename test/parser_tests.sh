# This file is part of Zutty.
# Contributed by AstroSnail <at protonmail dot com>

# This test relies on knowing the cursor position before and after sending a
# control sequence, and guessing where it should be if that control sequence
# were interpreted correctly. If a sequence happens to be a valid cursor
# movement that this test doesn't know about, it can trigger spurious failures.
# Many cursor movements are excluded (and some more relevant ones are tested
# specifically), but this detail must be considered when reviewing test results.

# Comments referencing other terminal emulators are based on tests with these:
# - Kitty 0.48.2
# - LXTerminal 0.4.1 (representing VTE 0.84.1)
# - Rxvt-unicode 9.31
# - Vim :terminal (vim 9.2.1036)
# - XTerm 410

#   LXterminal is exceptionally slow at this test, but it's also exceptionally
# correct. The only failure is ESC Z, upon which VTE chose to emulate SCI
# (single character introducer) rather than DECID. 299s real time.
#   XTerm's failures only start deep, once missing a ResetState after handling
# DECRQUPSS, and many more handling pathological sequences of CSI intermediate
# characters and C0 controls. 12s real time.
#   Vim :terminal fails mostly at mis-handling NUL bytes, probably due to an
# internal conversion of NUL bytes to LF. Besides that it fails to handle more
# than 1 intermediate CSI character in many cases. 13s real time.
#   Rxvt-unicode uniquely seems to *skip* unknown CSI intermediate characters
# instead of ignoring the whole sequence. This causes lots of spurious failures
# due to an invalid code being interpreted as a cursor movement. It also seems
# to mis-handle DEL and ESC @ and CSI restarts. 12s real time.
#   Kitty doesn't pass most cases. Some invalid codes even corrupt its SGR
# parser. 151s real time.
#   Zutty is tested against this and passes all tests. 12s real time.

# Printable characters are assumed to print in ground state.

# C0 control codes with special meaning:
# ^E  ENQ  May elicit a response from the terminal. The response may be ^F ACK,
#          or the same as the response to DA1, or a customizable string.
# ^G  BEL  May ring the terminal bell, or may flash the screen.
# ^H  BS   Moves the cursor left one space. May trigger reverse wraparound if
#          sent when the cursor is at the left margin.
# ^I  TAB  Moves the cursor right until the next tab stop, or the right margin.
# ^J  LF   Moves the cursor down one line. May scroll the screen up if sent when
#          the cursor is at the bottom margin.
# ^K  VT   Same as ^J LF.
# ^L  FF   Same as ^J LF.
# ^M  CR   Moves the cursor to the left margin of the current line.
# ^N  LS1  Switches to Alternate Character Set.
# ^O  LS0  Switches to Standard Character Set.
# ^X  CAN  Cancels any control sequence in progress.
# ^Z  SUB  Cancels any control sequence in progress. May print an error character,
#          such as U+2426 SYMBOL FOR SUBSTITUTE FORM TWO.
# ^[  ESC  Cancels any control sequence in progress and begins one anew.
# All other C0 control codes have no special meaning to a VT.

# C0 control codes which don't move the cursor and don't change state.
# Vim :terminal indexes on a null byte, likely bug.
simple_c0=(
   000 001 002 003 004 005 006 007
                           016 017
   020 021 022 023 024 025 026 027
       031         034 035 036 037
)
for oct in "${simple_c0[@]}"; do
   exam=("${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "C0 control ${pri} shouldn't move the cursor or enter a control sequence."
done

# C0 control codes which may move the cursor and stay in ground state. So-called
# Format effector characters.
exam=(010)
examine_trailing 0 -1 "Backspace should move the cursor left one space."
# This depends on the configuration of the tab stops, but is often initially
# every 8 columns.
exam=(011)
examine_trailing 0 $((8 - start_column)) \
   "Horizontal tab should move the cursor right to the next tab stop."
exam=(012)
examine_trailing 1 0 \
   "Line feed should move the cursor down one line on the same column."
exam=(013)
examine_trailing 1 0 \
   "Vertical tab should move the cursor down one line on the same column."
exam=(014)
examine_trailing 1 0 \
   "Form feed should move the cursor down one line on the same column."
exam=(015)
examine_trailing 0 $((- start_column)) \
   "Carriage return should move the cursor to the left margin on the same line."

# Other 7-bit codes.
exam=(030)
examine_trailing 0 0 \
   "Cancel shouldn't move the cursor or enter a control sequence."
# This is subjective. Kitty, Rxvt-unicode and Vim :terminal don't do this, VTE
# and XTerm do.
# exam=(032)
# examine_trailing 0 1 "Substitute should print an error character."
exam=(177)
examine_trailing 0 0 \
   "Delete shouldn't move the cursor or enter a control sequence."

# C1 control codes with special meaning:
# ESC D  IND
# ESC E  NEL
# ESC F  SSA    hpLowerleftBugCompat
# ESC H  HTS
# ESC I  HTJ    VTE only
# ESC M  RI
# ESC N  SS2
# ESC O  SS3
# ESC P  DCS
# ESC V  SPA
# ESC W  EPA
# ESC X  SOS
# ESC Z  SCI    DECID, obsolete form of DA1
# ESC [  CSI
# ESC \  ST
# ESC ]  OSC
# ESC ^  PM
# ESC _  APC
# All other C1 control codes have no special meaning to a VT.

# C1 control codes which don't move the cursor and return to ground state.
# Rxvt-unicode eats a character after ESC @ (PAD) (including another ESC).
# VTE eats a character after ESC Z (SCI) (including many controls but not ESC).
simple_c1=(
   100 101 102 103         106 107
   110     112 113 114     116 117
       121 122 123 124 125 126 127
       131 132     134
)
for oct in "${simple_c1[@]}"; do
   exam=(033 "${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "C1 control ${pri} shouldn't move the cursor and should return to ground state."
done

# Escape codes (without intermediate characters) with special meaning:
# ESC 6  DECBI    Back index
# ESC 7  DECSC    Save cursor
# ESC 8  DECRC    Restore cursor
# ESC 9  DECFI    Forward index
# ESC <           Exit VT52 mode (Enter VT100 mode)
# ESC =  DECKPAM  Application keypad
# ESC >  DECKPNM  Normal keypad
# ESC c  RIS      Full reset
# ESC l           Memory lock
# ESC m           Memory unlock
# ESC n  LS2
# ESC o  LS3
# ESC |  LS3R
# ESC }  LS2R
# ESC ~  LS1R
# All other escape codes (without intermediate characters) have no special
# meaning to a VT.

# Escape sequences with no intermediate characters which don't move the cursor
# and return to ground state.
simple_esc_1=(
   060 061 062 063 064 065
           072 073 074 075 076 077
   140 141 142     144 145 146 147
   150 151 152 153 154 155 156 157
   160 161 162 163 164 165 166 167
   170 171 172 173 174 175 176
)
for oct in "${simple_esc_1[@]}"; do
   exam=(033 "${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "Escape sequence ${pri} shouldn't move the cursor and should return to ground state."
done

# ESC SP F  S7C1T
# ESC SP G  S8C1T
# ESC #  3  DECDHL top half (is there a DECSHL?)
# ESC #  4  DECDHL bottom half
# ESC #  5  DECSWL
# ESC #  6  DECDWL
# ESC #  8  DECALN Draws E all over the screen, moves cursor to top left.
simple_esc_2=(
   060 061 062 063 064 065 066 067
   070 071 072 073 074 075 076 077
   100 101 102 103 104 105 106 107
   110 111 112 113 114 115 116 117
   120 121 122 123 124 125 126 127
   130 131 132 133 134 135 136 137
   140 141 142 143 144 145 146 147
   150 151 152 153 154 155 156 157
   160 161 162 163 164 165 166 167
   170 171 172 173 174 175 176
)
esc_intermediate=(
   040 041 042 043 044 045 046 047
   050 051 052 053 054 055 056 057
)
for oct in "${simple_esc_2[@]}"; do
   for int1 in "${esc_intermediate[@]}"; do
      case ${int1},${oct} in
      (040,10[67]|043,06[3-6]|043,070) continue;;
      (*) ;;
      esac
      exam=(033 "${int1}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "Escape sequence ${pri} shouldn't move the cursor and should return to ground state."
   done
done

# don't loop all dispatches. ESC ... O should be meaningless
oct=117
for int1 in "${esc_intermediate[@]}"; do
   for int2 in "${esc_intermediate[@]}"; do
      exam=(033 "${int1}" "${int2}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "Escape sequence ${pri} shouldn't move the cursor and should return to ground state."
   done
done

oct=117
for int1 in "${esc_intermediate[@]}"; do
   for int2 in "${esc_intermediate[@]}"; do
      for int3 in "${esc_intermediate[@]}"; do
         exam=(033 "${int1}" "${int2}" "${int3}" "${oct}")
         printable
         pri=${REPLY}
         examine_trailing 0 0 \
            "Escape sequence ${pri} shouldn't move the cursor and should return to ground state."
      done
   done
done

# test embedded C0 controls
oct=117
for int1 in "${esc_intermediate[@]}"; do
   for ctl1 in "${simple_c0[@]}"; do
      exam=(033 "${ctl1}" "${int1}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "Escape sequence ${pri} shouldn't move the cursor and should return to ground state."
      exam=(033 "${int1}" "${ctl1}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "Escape sequence ${pri} shouldn't move the cursor and should return to ground state."
   done
done
exam=(033 010 117)
examine_trailing 0 -1 "Backspace shouldn't cancel ESC and should work."

# Reset tabs stops to every 8 columns starting from the 9th; earlier testing
# messed up tabs via ESC H (HTS / Tab Set)
reset_for_exam

exam=(033 011 117)
examine_trailing 0 $((8 - start_column)) \
   "Horizontal tab shouldn't cancel ESC and should work."
exam=(033 012 117)
examine_trailing 1 0 "Line feed shouldn't cancel ESC and should work."
exam=(033 013 117)
examine_trailing 1 0 "Vertical tab shouldn't cancel ESC and should work."
exam=(033 014 117)
examine_trailing 1 0 "Form feed shouldn't cancel ESC and should work."
exam=(033 015 117)
examine_trailing 0 $((- start_column)) \
   "Carriage return shouldn't cancel ESC and should work."
exam=(033 030 117)
examine_trailing 0 1 "Cancel should cancel ESC."
# 032?
exam=(033 177 117)
examine_trailing 0 0 "Delete shouldn't cancel ESC."

# test ESC restart
oct=117
for int1 in "${esc_intermediate[@]}"; do
   exam=(033 "${int1}" 033 "${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "Restarted escape sequence ${pri} shouldn't move the cursor and should return to ground state."
done

# CSI A
# CSI B
# CSI C
# CSI D
# CSI E
# CSI F
# CSI G
# CSI H
# CSI I
# CSI L
# CSI M
# CSI Z
# CSI `
# CSI a
# CSI b  vim terminal
# CSI d
# CSI e
# CSI f
# CSI j  vim terminal
# CSI k  vim terminal
# CSI r
# CSI s  vim terminal
# CSI u
simple_csi_1=(
   100
           112 113         116 117
   120 121 122 123 124 125 126 127
   130 131     133 134 135 136 137
               143             147
   150 151         154 155 156 157
   160 161         164     166 167
   170 171 172 173 174 175 176
)
for oct in "${simple_csi_1[@]}"; do
   exam=(033 133 "${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
done

# CSI + p  DECSR secure reset (VTE, not XTerm)
simple_csi_2=(
   100 101 102 103 104 105 106 107
   110 111 112 113 114 115 116 117
   120 121 122 123 124 125 126 127
   130 131 132 133 134 135 136 137
   140 141 142 143 144 145 146 147
   150 151 152 153 154 155 156 157
   160 161 162 163 164 165 166 167
   170 171 172 173 174 175 176
)
# don't test digits and : and ;
# they are assumed to work fine
# this means we test with default parameters
csi_intermediate=(
   040 041 042 043 044 045 046 047
   050 051 052 053 054 055 056 057
                   074 075 076 077
)
# XTerm eats a character after CSI & u
# in fact, you can do CSI & u u u u u to trigger DECRQUPSS multiple times!
# Rxvt-unicode seems to ignore many intermediates and process dispatches as
# though there weren't any.
for oct in "${simple_csi_2[@]}"; do
   for int1 in "${csi_intermediate[@]}"; do
      case ${int1},${oct} in
      (053,160) continue;;
      (*) ;;
      esac
      exam=(033 133 "${int1}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
   done
done

csi_intermediate_2=(
   040 041 042 043 044 045 046 047
   050 051 052 053 054 055 056 057
   060 061 062 063 064 065 066 067
   070 071 072 073 074 075 076 077
)
# don't loop all dispatches. CSI ... O should be meaningless
oct=117
for int1 in "${csi_intermediate_2[@]}"; do
   exam=(033 133 "${int1}" "${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
done

oct=117
for int1 in "${csi_intermediate_2[@]}"; do
   for int2 in "${csi_intermediate_2[@]}"; do
      exam=(033 133 "${int1}" "${int2}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
   done
done

oct=117
for int1 in "${csi_intermediate_2[@]}"; do
   for int2 in "${csi_intermediate_2[@]}"; do
      for int3 in "${csi_intermediate_2[@]}"; do
         exam=(033 133 "${int1}" "${int2}" "${int3}" "${oct}")
         printable
         pri=${REPLY}
         examine_trailing 0 0 \
            "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
      done
   done
done

# test embedded C0 controls
oct=117
for int1 in "${csi_intermediate_2[@]}"; do
   for ctl1 in "${simple_c0[@]}"; do
      exam=(033 133 "${ctl1}" "${int1}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
      exam=(033 133 "${int1}" "${ctl1}" "${oct}")
      printable
      pri=${REPLY}
      examine_trailing 0 0 \
         "CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
   done
done
exam=(033 133 010 117)
examine_trailing 0 -1 "Backspace shouldn't cancel CSI and should work."
exam=(033 133 011 117)
examine_trailing 0 $((8 - start_column)) \
   "Horizontal tab shouldn't cancel CSI and should work."
exam=(033 133 012 117)
examine_trailing 1 0 "Line feed shouldn't cancel CSI and should work."
exam=(033 133 013 117)
examine_trailing 1 0 "Vertical tab shouldn't cancel CSI and should work."
exam=(033 133 014 117)
examine_trailing 1 0 "Form feed shouldn't cancel CSI and should work."
exam=(033 133 015 117)
examine_trailing 0 $((- start_column)) \
   "Carriage return shouldn't cancel CSI and should work."
exam=(033 133 030 117)
examine_trailing 0 1 "Cancel should cancel CSI."
# 032?
exam=(033 133 177 117)
examine_trailing 0 0 "Delete shouldn't cancel CSI."

# test CSI restart
oct=117
for int1 in "${csi_intermediate_2[@]}"; do
   exam=(033 133 "${int1}" 033 133 "${oct}")
   printable
   pri=${REPLY}
   examine_trailing 0 0 \
      "Restarted CSI sequence ${pri} shouldn't move the cursor and should return to ground state."
done

# vim:sw=3:et:tw=80:
