project=$(find ~/source -maxdepth 2 -name .git -type d | sed 's/\/.git//g' | gum filter)
cd $project

id=$project
tmux new-session -d -s $id
tmux send 'pull' ENTER
tmux attach -t $id
