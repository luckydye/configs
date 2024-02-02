#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Terminal
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName scripts

osascript -e 'tell application "System Events" to set activeApp to name of first application process whose frontmost is true'
if [ "$activeApp" = "Terminal" ]; then
	osascript -e 'tell application "Terminal" to set visible of front window to false'
else
	open -a Terminal
fi
