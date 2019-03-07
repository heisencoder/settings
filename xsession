#!/bin/sh
xrandr --dpi 120
# Use 25 MiB of RAM for debug logs
exec i3 --shmlog-size=26214400
