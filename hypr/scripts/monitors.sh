#!/bin/sh
# Switch monitor setups (replaces the xrandr bindings from i3).
#   external: use the external monitor(s) only and turn off the laptop screen
#   all:      turn every connected monitor on
#   auto:     "external" if an external monitor is connected, else "all"
#   watch:    run "auto" now, switch to workspace 7, then run "auto" again
#             whenever an external monitor is plugged in or unplugged, or the
#             config reloads (a reload turns the laptop screen back on)
laptop=eDP-1

# Connected monitors other than the laptop screen (Hyprland adds a FALLBACK
# monitor while nothing is connected).
externals() {
  hyprctl monitors all -j | jq --arg l "$laptop" \
    '[.[] | select(.name != $l and .name != "FALLBACK")] | length'
}

case "$1" in
  external)
    if [ "$(externals)" -gt 0 ]; then
      hyprctl keyword monitor "$laptop, disable"
    else
      notify-send "No external monitor connected"
    fi
    ;;
  all)
    # Same as the monitor= line in hyprland.conf.
    hyprctl keyword monitor "$laptop, preferred, auto, 1"
    ;;
  auto)
    if [ "$(externals)" -gt 0 ]; then
      hyprctl keyword monitor "$laptop, disable"
    else
      hyprctl keyword monitor "$laptop, preferred, auto, 1"
    fi
    ;;
  watch)
    "$0" auto
    hyprctl dispatch workspace 7
    socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
      while IFS= read -r event; do
        case "$event" in
          # Turning the laptop screen on or off sends these too; ignore them.
          "monitoradded>>$laptop" | "monitorremoved>>$laptop") ;;
          monitoradded\>\>* | monitorremoved\>\>* | configreloaded\>\>*) "$0" auto ;;
        esac
      done
    ;;
  *)
    echo "usage: $0 external|all|auto|watch" >&2
    exit 1
    ;;
esac
