file=$(fzf)

if [ -z "$file" ]
then
  echo "Canceled"
else
  nvim $file
fi
