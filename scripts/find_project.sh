cd $(find ~/source -maxdepth 2 -name .git -type d | sed 's/\/.git//g' | gum filter)

tmux new-session -d -s devenv-session
tmux send 'pull' ENTER
tmux a
