#!/bin/sh
xrandr --dpi 120
# Start the imwheel app, which adjusts the mouse scroll speed.
# To install: sudo apt install imwheel
imwheel --kill
# Use 25 MiB of RAM for debug logs
exec i3 --shmlog-size=26214400
