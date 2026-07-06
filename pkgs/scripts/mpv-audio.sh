#!/usr/bin/env bash

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/mpv-audio.pid"

# Function to stop mpv
stop_mpv() {
    if [ -f "$PIDFILE" ]; then
        pid=$(cat "$PIDFILE")
        if kill "$pid" 2>/dev/null; then
            notify-send "MPV Audio" "Stopped"
        fi
        rm -f "$PIDFILE"
    fi
}

# Check if mpv is already running (toggle)
if [ -f "$PIDFILE" ]; then
    stop_mpv
    exit 0
fi

# Get URL from argument or clipboard
if [ -n "$1" ]; then
    url="$1"
else
    if command -v wl-paste >/dev/null 2>&1; then
        url=$(wl-paste 2>/dev/null)
    else
        notify-send "Error" "No clipboard utility found. Install wl-clipboard."
        exit 1
    fi
fi

# Check if URL is empty
if [ -z "$url" ]; then
    notify-send "Error" "No URL provided and clipboard is empty."
    exit 1
fi

# Trim whitespace
url=$(echo "$url" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# Validate URL
if [[ ! "$url" =~ ^https?:// ]]; then
    notify-send "Error" "Invalid URL: $url"
    exit 1
fi

# Start mpv detached (no window, background process)
notify-send "MPV Audio" "Playing: $url"
nohup mpv --no-video --really-quiet "$url" >/dev/null 2>&1 &
echo $! > "$PIDFILE"
disown
