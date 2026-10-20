export PS1="\u@\h:\w$ "
export PROMPT_COMMAND=

printf "\e[H\e[J\n"

printf "\e[38;2;200;150;100mHello in RGB color\n"
printf "\e[38;2;200;150;100;22mSame after attribute setting\n"
printf "\e[48;2;100;50;20;35mHello in RGB background\n"
printf "\e[48;2;100;50;20;35;22mSame after attribute setting\n"

sleep 3
