#!/bin/sh
# Run waybar's stock "now playing" script, but decode the HTML entities it
# adds (it turns "&" into "&amp;").  The module also sets "escape": true, so
# without this waybar escapes the text a second time and shows "&amp;".
# Decoding here also covers entities that come from the player itself.
/usr/share/waybar/custom_modules/mediaplayer.py "$@" 2>/dev/null | python3 -u -c '
import html, json, sys
for line in sys.stdin:
    line = line.strip()
    try:
        data = json.loads(line) if line else None
    except ValueError:
        data = None
    if isinstance(data, dict):
        if isinstance(data.get("text"), str):
            data["text"] = html.unescape(data["text"])
        print(json.dumps(data), flush=True)
    else:
        print(html.unescape(line), flush=True)
'
