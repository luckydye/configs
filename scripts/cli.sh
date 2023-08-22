#!/bin/zsh

# one line input (also secret)
# gum input
# gum input --password

# multi line input
# gum write

# text filter options
# echo "Option 1
# Option 2
# Something else" | gum filter

# choose option
# echo "Pick a card, any card..."
# CARD=$(gum choose --height 15 {{A,K,Q,J},{10..2}}" "{♠,♥,♣,♦})
# echo "Was your card the $CARD?"

# confirm
# gum confirm && echo "file removed" || echo "File not removed"

# select file
# nvim $(gum file $HOME)

# pager/scroller
# gum pager < $(gum file $HOME)

# spinner
# gum spin --spinner minidot --title "Buying Bubble Gum..." -- sleep 5

# choose row in table
# gum table < flavors.csv | cut -d ',' -f 1

# select key from skate
skate list -k | gum filter | xargs skate get

# choose command from history
# HISTFILE=~/.zsh_history
# gum filter < $HISTFILE --height 40

