export PS1="$ "
export PROMPT_COMMAND=

printf "\e[H\e[J"
for row in {1..20} ; do
    printf "\e[%d;1H%2d" ${row} ${row}
done

# Scrolling region: rows 5 to 10; positions relative to it in origin mode
printf "\e[5;10r\e[?6h"
printf "\e[1;5HRow 1 in origin mode: top of region"
printf "\e[24;5HRow 24 in origin mode: clamped to bottom of region"
printf "\e[?6l\e[r\e[22;1H"

touch .complete
sleep 3
