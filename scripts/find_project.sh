cd $(find ~/source -maxdepth 4 -name .git -type d | sed 's/\/.git//g' | gum filter)

tmux new-session -d -s devenv-session
tmux send 'pull' ENTER
tmux a
