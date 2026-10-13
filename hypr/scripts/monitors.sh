#!/bin/sh
# Switch monitor setups (replaces the xrandr bindings from i3).
#   external: use the external monitor(s) only and turn off the laptop screen
#   all:      turn every connected monitor on
laptop=eDP-1
case "$1" in
  external)
    if hyprctl monitors all -j | jq -e --arg l "$laptop" 'any(.[]; .name != $l)' >/dev/null; then
      hyprctl keyword monitor "$laptop, disable"
    else
      notify-send "No external monitor connected"
    fi
    ;;
  all)
    hyprctl keyword monitor "$laptop, preferred, auto, auto"
    ;;
  *)
    echo "usage: $0 external|all" >&2
    exit 1
    ;;
esac
