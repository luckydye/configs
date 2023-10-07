nvim $(find ~/source -maxdepth 4 -name .git -type d | sed 's/\/.git//g' | gum filter)
