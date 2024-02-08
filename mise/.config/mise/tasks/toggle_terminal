#!/bin/bash
# mise hide=true

# Get the ID of the active window
active_window=$(xdotool getactivewindow)

# Get the class of the active window
active_window_class=$(xprop -id "$active_window" | grep WM_CLASS | awk '{print $4}')

# Find the terminal window
terminal_window=$(xdotool search --class gnome-terminal)

if [ "$active_window_class" = "\"Gnome-terminal\"" ]; then
    # If Terminal is focused, minimize it
    xdotool windowminimize "$active_window"
else
    # If Terminal is not focused, bring it to the front
    xdotool windowactivate "$terminal_window"
fi
