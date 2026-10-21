export PS1="$ "
export PROMPT_COMMAND=

printf "\e[H\e[J\nPrimary screen\n"

# N.B.: Sleep inside control sequences to have them arrive split
# across multiple reads on the terminal side.
printf "\e["; sleep 1; printf "?1049h"
printf "Alternate screen, cursor hidden"
printf "\e"; sleep 1; printf "[?25l"

touch .complete
sleep 3
printf "\e[?25h\e[?1049l\n"
touch .complete
sleep 3
