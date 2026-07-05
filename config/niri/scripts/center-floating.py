#!/usr/bin/env python3
"""Center calibre Preferences dialog on the monitor via niri IPC."""

import json
import re
import subprocess
import time

WINDOW_TITLE_RE = re.compile(r"calibre\s+-\s+Preferences")


def niri_json(args):
    r = subprocess.run(["niri", "msg", "--json", *args], capture_output=True, text=True)
    return json.loads(r.stdout) if r.stdout else None


def center(wid):
    subprocess.run(
        ["niri", "msg", "action", "center-window", "--id", str(wid)],
        capture_output=True,
    )


def main():
    centered = False
    while True:
        windows = niri_json(["windows"])
        found = False
        if windows:
            for w in windows:
                if WINDOW_TITLE_RE.search(w.get("title", "")):
                    found = True
                    if not centered:
                        center(w["id"])
                        centered = True
                    break
        if not found:
            centered = False
        time.sleep(0.1)


if __name__ == "__main__":
    main()
