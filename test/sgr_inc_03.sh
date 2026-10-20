export PS1="$ "
export PROMPT_COMMAND=

printf "\e[0m\e[H\e[J\n"

# N.B.: Sleep between steps so each update arrives as a separate (partial)
# redraw. Attributes must survive redraws of cells not updated since.
sleep 1
printf "\e[9mCrossed-out text\e[0m\n"
printf "\e[4mUnderlined\e[0m \e[7mInverse\e[0m \e[4;9mUnderlined and crossed-out\e[0m\n"
sleep 1
printf "\e[2;5H"
sleep 1
printf "\e[3;20H"
sleep 1
printf "\e[5;1HAfter partial redraws\n"

touch .complete
sleep 3
