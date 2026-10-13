#!/bin/sh
# Feed waybar's media buttons: print one JSON line whenever the media player's
# status changes.  An empty "text" hides the buttons when nothing is playing.
playerctl --follow status 2>/dev/null | while read -r status; do
  case "$status" in
    Playing|Paused|Stopped)
      class=$(printf '%s' "$status" | tr '[:upper:]' '[:lower:]')
      printf '{"text":"%s","alt":"%s","class":"%s"}\n' "$status" "$status" "$class"
      ;;
    *)
      printf '{"text":""}\n'
      ;;
  esac
done
