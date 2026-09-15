#!/usr/bin/env bash

# This file is part of Zutty.
# Contributed by AstroSnail <at protonmail dot com>

set -eu
IFS=

cd $(dirname $0)

usage() {
   echo "Usage: $0 [-ahst] [-o output]"
   echo "  -a         Abort on first failure."
   echo "  -h         Display this help text."
   echo "  -o output  Log to this file (./parser_errors.log by default)."
   echo "  -s         Also log successes."
   echo "  -t         Begin the test."
   echo "The test will likely trash the state of your terminal. At the end the"
   echo "'reset' tool will be run that might restore it, but it's recommended"
   echo "to start a separate terminal just for this test."
   echo "The test should take about 12 seconds of CPU time. The amount of real"
   echo "time it needs is at least that much, but will depend on how fast the"
   echo "terminal processes escape sequences and replies to requests."
}

output=./parser_errors.log
abort_on_1st_fail=n
log_success=n
begin_test=n
while getopts aho:st arg; do
   case ${arg} in
   (a)
      abort_on_1st_fail=y
      ;;
   (h)
      usage
      exit 0
      ;;
   (o)
      output=${OPTARG}
      ;;
   (s)
      log_success=y
      ;;
   (t)
      begin_test=y
      ;;
   (*)
      usage
      exit 1
      ;;
   esac
done
if (( OPTIND <= $# )); then
   usage
   exit 1
fi
if [[ ${begin_test} != y ]]; then
   usage
   exit 0
fi

declare -i total_exams total_pass
total_exams=0
total_pass=0

reset_for_exam() {
   reset 2>&1
   stty raw -echo
}

stty_save=$(stty -g)
reset_for_exam
exec 3>&2 2>"${output}"
atexit() {
   exec 2>&3 3>&-
   reset
   stty "${stty_save}"
   echo "Test complete."
   echo "Tests run: ${total_exams}"
   echo "Tests passed: ${total_pass}"
   echo "See ${output}."
   touch .complete
   sleep 3
}
trap atexit EXIT

cpr() {
   total_exams+=1
   local input c
   input=
   until [[ ${input} =~ $'\033\133'([0-9]+)\;([0-9]+)[0-9\;]*R$ ]]; do
      # This might block if we don't get a CPR response.
      read -d '' -n 1 -r c
      input=${input}${c}
   done
   declare -i expect_line expect_column
   expect_line=$1
   expect_column=$2
   if (( BASH_REMATCH[1] != expect_line )) || (( BASH_REMATCH[2] != expect_column )); then
      echo "FAIL: $3" >&2
      echo "  expected: ${expect_line} ${expect_column}" >&2
      echo "  got:      ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}" >&2
      if [[ ${abort_on_1st_fail} == y ]]; then
          echo "Aborting." >&2
          echo "Tests run: ${total_exams}" >&2
          echo "Tests passed: ${total_pass}" >&2
          exit 1
      fi
   elif [[ ${log_success} == y ]]; then
      echo "SUCCESS: $3" >&2
      total_pass+=1
   else
      total_pass+=1
   fi
}

# Move the cursor a little ways into the screen. Not only does this help us to
# detect movement in all directions, but also to avoid the ambiguity of cursor
# position reports on the first line with modified F3 keypresses. Zero-based.
start_line=2
start_column=2

# avoid calling programs in hot loops, that's very slow
# an ansi terminal shouldn't have trailing newlines to lose here
CUP=$(tput cup "${start_line}" "${start_column}")
U7=$(tput u7)

# Arguments:
#   exam = Array of octal codes to send to the terminal.
#   $1 = Expected lines down from initial position.
#   $2 = Expected columns right from initial position.
#   $3 = Test description.
examine() {
   printf %s "${CUP}"
   local oct
   for oct in "${exam[@]}"; do
      printf %b "\\0${oct}"
   done
   printf %s "${U7}"
   declare -i expect_line expect_column
   expect_line=$1
   expect_column=$2
   expect_line+=start_line+1
   expect_column+=start_column+1
   # tput u6 has the response template, but I don't see a good way to use it.
   # Sending several codes before reading CPR doesn't seem to bring a meaningful
   # performance improvement, so do it one at a time.
   cpr "${expect_line}" "${expect_column}" "$3"
}
# $1 is string to send, lines columns and description shifted up
examine_string() {
   printf %s "${CUP}"
   printf %s "$1"
   printf %s "${U7}"
   declare -i expect_line expect_column
   expect_line=$2
   expect_column=$3
   expect_line+=start_line+1
   expect_column+=start_column+1
   cpr "${expect_line}" "${expect_column}" "$4"
}
examine_trailing() {
   declare -i expect_column
   expect_column=$2
   # examine "$1" $((expect_column)) "$3"
   # Extra characters help the terminal parser return to a stable state in
   # preparation for CPR. For example, Rxvt-unicode drops the character
   # following ESC @ (PAD), so it doesn't properly receive CPR if it's sent
   # immediately after.
   # Random message so that the terminal doesn't have a stuck appearance while
   # testing.
   if (( RANDOM % 2 == 0 )); then
      exam+=(110 105 114 114 117) # HELLO
   else
      exam+=(127 117 122 114 104) # WORLD
   fi
   examine "$1" $((expect_column + 5)) "$3"
}

printable() {
   declare -i dec
   local oct
   REPLY=
   for oct in "${exam[@]}"; do
      dec=0${oct}
      if (( dec < 32 )); then
         printf -v oct %03o $((dec + 64))
         printf -v REPLY %s^%b "${REPLY}" "\\0${oct}"
      elif (( dec == 127 )); then
         printf -v oct %03o $((dec - 64))
         printf -v REPLY %s^%b "${REPLY}" "\\0${oct}"
      else
         printf -v REPLY %s%b "${REPLY}" "\\0${oct}"
      fi
   done
   IFS=' '
   REPLY+=" (${exam[*]})"
   IFS=
}

examine_string "Stuck here? CTRL-C!" 0 19 "CPR should work."
clear

. parser_tests.sh

# vim:sw=3:et:tw=80:
