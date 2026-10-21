export PS1="\u@\h:\w$ "
export PROMPT_COMMAND=

printf "\e[0m\e[H\e[J\n"

printf "\e[38;2;200;150;100mRGB color\n"
printf "\e[1mSame after separate bold setting\n"
printf "\e[22mSame after separate bold reset\n"
printf "\e[10mSame after separate font reset\n"
printf "\e[48;2;100;50;20mRGB background\n"
printf "\e[1mSame after separate bold setting\n"
printf "\e[0mDefault colors after reset\n"

touch .complete
sleep 3
