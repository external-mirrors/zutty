export PS1="$ "
export PROMPT_COMMAND=

printf "\e[H\e[J\e[3J"

for x in {1..30} ; do
    printf "Before margins %2d\n" $x
done

# Lines scrolling out of a scrolling region do not enter the history
printf "\e[1;23r\e[23;1H"
for x in {1..30} ; do
    printf "Inside margins %2d\n" $x
done
printf "\e[r\e[24;1H"
