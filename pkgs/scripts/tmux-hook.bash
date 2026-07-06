#!/usr/bin/env bash

settings=$HOME/.config/noctalia/settings.json
auto_colors=$(jq -r '.colorSchemes.useWallpaperColors' "$settings")

if [[ $auto_colors = false ]]; then
    exit
fi
tmux source-file ~/.config/tmux/theme.conf >/dev/null 2>&1 || true
