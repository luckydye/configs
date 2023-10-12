cd $(find ~/source -maxdepth 2 -name .git -type d | sed 's/\/.git//g' | gum filter)

id=$(uuidgen)
tmux new-session -d -s $id
tmux send 'pull' ENTER
tmux attach -t $id
