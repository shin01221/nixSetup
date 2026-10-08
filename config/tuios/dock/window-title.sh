#!/bin/sh
# Focused window title for the right side of the dock.
# Truncated to 20 chars, unless click-to-expand armed it for this window
# (see window-title-toggle.sh): then the full title shows. Switching focus
# to another window auto-collapses, since the flag names a window id.
FLAG="${XDG_CACHE_HOME:-$HOME/.cache}/tuios/window-title-full"
export TITLE_FLAG="$FLAG"
tuios list-windows --json 2>/dev/null | python3 -c 'import json,sys,os
try:
    d = json.load(sys.stdin)
except Exception:
    raise SystemExit
flag = os.environ.get("TITLE_FLAG", "")
want = ""
try:
    with open(flag) as f:
        want = f.read().strip()
except OSError:
    pass
for w in d.get("windows", []):
    if w.get("focused"):
        t = w.get("display_name") or w.get("title") or ""
        wid = w.get("id") or w.get("window_id") or ""
        if want and wid and want == wid:
            print(t)
        else:
            print(t[:20])
        break
'
