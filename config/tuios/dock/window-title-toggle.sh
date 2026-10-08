#!/bin/sh
# on-click for the dock title cell: toggle full title for the focused window.
# Arms (or disarms) the flag that window-title.sh reads, then repaints the cell.
FLAG="${XDG_CACHE_HOME:-$HOME/.cache}/tuios/window-title-full"
mkdir -p "$(dirname "$FLAG")"
wid=$(tuios list-windows --json 2>/dev/null | python3 -c 'import json,sys
try:
    d = json.load(sys.stdin)
except Exception:
    raise SystemExit
for w in d.get("windows", []):
    if w.get("focused"):
        print(w.get("id") or w.get("window_id") or "")
        break')
if [ -z "$wid" ]; then
  exit 0
fi
if [ -f "$FLAG" ] && [ "$(cat "$FLAG" 2>/dev/null)" = "$wid" ]; then
  rm -f "$FLAG"
else
  printf '%s' "$wid" > "$FLAG"
fi
tuios refresh-dock custom/window_title >/dev/null 2>&1
