project=$(find ~/source -maxdepth 2 -name .git -type d | sed 's/\/.git//g' | gum filter)

if [ -z "$project" ]
then
  echo "You need to select a project."
else  
  cd $project
  id=$project
    
  if [ -z "$TMUX" ]
  then
    tmux new-session -d -s $id
    tmux send 'pull' ENTER
    tmux attach -t $id
  else  
    tmux switch-client $id
  fi
fi
