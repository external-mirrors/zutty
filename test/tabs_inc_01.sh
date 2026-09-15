reset
export PS1="\u@\h:\w$ "
export PROMPT_COMMAND=

printf "\e[H\e[J"

echo "123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
echo
echo "Default tab stops: every eight characters, starting at col 9"
printf "\ta\tb\tc\td\te\n"
echo
echo "HTS - Tab Set, column 4"
printf "   \eH\r"
printf "\ta\tb\tc\td\te\n"
echo
echo "TBC - Tab Clear, column 9 only"
printf "        \e[g\r"
printf "\ta\tb\tc\td\te\n"
echo
echo "TBC - Tab Clear, all columns"
printf "\e[3g\r"
printf "\ta\tb\tc\td\te"

sleep 3
