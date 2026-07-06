#!/usr/bin/env bash

APP_ID="$1"

if [ -z "$APP_ID" ]; then
    echo "Error: No app-id provided."
    exit 1
fi

if pgrep -f "foot.*--app-id=$APP_ID" >/dev/null; then
    pkill -f "foot.*--app-id=$APP_ID"
else
    foot --app-id="$APP_ID" env NO_TMUX=1 fish -c \
        'tmux attach -t scratch-term 2>/dev/null || tmux new -s scratch-term'
fi
