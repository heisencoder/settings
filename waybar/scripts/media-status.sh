#!/bin/sh
# Feed waybar's media buttons: print one JSON line whenever the media player's
# status changes.  An empty "text" hides the buttons when nothing is playing.
#
# This runs with SIGPIPE ignored (inherited from Hyprland, or from systemd's
# IgnoreSIGPIPE=yes), so a write to a waybar that has gone away fails instead
# of killing this script.  Stop then, including playerctl, which would
# otherwise keep running.
stop() {
  pkill -P $$ -x playerctl
  exit
}

playerctl --follow status 2>/dev/null | while read -r status; do
  case "$status" in
    Playing|Paused|Stopped)
      class=$(printf '%s' "$status" | tr '[:upper:]' '[:lower:]')
      printf '{"text":"%s","alt":"%s","class":"%s"}\n' "$status" "$status" "$class" || stop
      ;;
    *)
      printf '{"text":""}\n' || stop
      ;;
  esac
done
