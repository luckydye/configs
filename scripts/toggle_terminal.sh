#!/bin/bash

# Get the ID of the active window
active_window=$(xdotool getactivewindow)

# Get the class of the active window
active_window_class=$(xprop -id "$active_window" | grep WM_CLASS | awk '{print $4}')

# Check if the active window is Terminal
if [ "$active_window_class" = "\"gnome-terminal\"" ]; then
	# If Terminal is focused, minimize it
	xdotool windowminimize "$active_window"
else
	# If Terminal is not focused, bring it to the front
	gnome-terminal --window
fi
