export PS1="$ "
export PROMPT_COMMAND=

printf "\e[H\e[J\e[3J"

for x in {1..30} ; do
    printf "Before margins %2d\n" $x
done

# As in xterm, lines scrolling out of a scrolling region that starts at
# the top of the screen enter the history (the status line does not)
printf "\e[1;23r\e[24;1HStatus line\e[23;1H"
for x in {1..10} ; do
    printf "Inside margins %2d\n" $x
done
printf "\e[r\e[23;1H"
