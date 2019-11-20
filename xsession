#!/bin/sh
xrandr --dpi 120
# Use 25 MiB of RAM for debug logs
#exec i3 --shmlog-size=26214400

# Temporarily use locally built i3
exec /usr/local/google/home/mball/wrk/i3/build/i3 --shmlog-size=26214400
