if [ -z "$TMUX" ]
then
  rg $(gum input --prompt="Search pattern: ")
else
  pattern=$(gum input --prompt="Search pattern: ")
  tmux split-window -v
  tmux send-keys -t 1 "rg $pattern" Enter
fi
