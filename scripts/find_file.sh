file=$(fzf)

if [ -z "$project" ]
then
  echo ""
else
  nvim $file
fi
