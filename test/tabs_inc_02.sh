reset
export PS1="\u@\h:\w$ "
export PROMPT_COMMAND=

# HTS - Tab Set, columns 4 and 21
# TBC - Tab Clear, column 33
printf "\e[H\e[J"
printf "\e[1;4H\eH"
printf "\e[1;21H\eH\eH" # test adding duplicate at same col
printf "\e[1;33H\e[g"
printf "\e[H"

echo "123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
echo
echo "HTS - Tab Set: cols 4 and 21"
echo "TBC - Tab Clear: default stop at col 33"
echo
echo "Moving with tabs"
printf "\ta\tb\tc\td\te\tf\tg\th\ti\tj\tk\n"
echo
echo CHT - cursor forward tabulation
printf "\e[Ia\e[Ib\e[Ic\e[Id\e[Ie\e[If\e[Ig\e[Ih\e[Ii\e[Ij\e[Ik\n"
# by 2 tabs
printf "\e[2Ib\e[2Id\e[2If\e[2Ih\e[2Ij\n"
# by 3 tabs
printf "\e[3Ic\e[3If\e[3Ii\n"
echo
echo CBT - cursor backward tabulation
printf "\e[79C\e[Za\e[D\e[Zb\e[D\e[Zc\e[D\e[Zd\e[D\e[Ze\e[D\e[Zf\e[D\e[Zg\e[D\e[Zh\e[D\e[Zi\e[D\e[Zj\e[D\e[Zk\n"
# by 2 tabs
printf "\e[79C\e[2Zb\e[D\e[2Zd\e[D\e[2Zf\e[D\e[2Zh\e[D\e[2Zj\e[D\e[2Zl\n"
# by 3 tabs
printf "\e[79C\e[3Zc\e[D\e[3Zf\e[D\e[3Zi\e[D\e[3Zl\n"

sleep 3
