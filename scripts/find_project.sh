nvim $(find . -name .git -type d -maxdepth 4 | sed 's/\/.git//g' | gum filter)
