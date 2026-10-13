#!/bin/sh
# Save a screenshot to ~/Pictures/screenshots and copy it to the clipboard.
#   screenshot.sh       all screens
#   screenshot.sh area  select a region with the mouse
dir="$HOME/Pictures/screenshots"
mkdir -p "$dir"
file="$dir/screenshot_$(date +%Y%m%d_%H%M%S).png"
if [ "$1" = area ]; then
  region=$(slurp) || exit 0
  grim -g "$region" "$file"
else
  grim "$file"
fi
wl-copy --type image/png < "$file"
