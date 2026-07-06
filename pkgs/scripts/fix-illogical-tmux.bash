#!/usr/bin/env bash

tmux_config=$HOME/.config/tmux/tmux.conf

if rg -q '^#\s*source-file .*colors.conf' "$tmux_config" && rg -q '^\s*source-file .*theme.conf' "$tmux_config"; then
    sed -i 's|^#\s*source-file\s.*colors.conf|source-file ~/.config/tmux/colors.conf|' "$tmux_config"
    sed -i 's|^\s*source-file\s.*theme.conf|#source-file ~/.config/tmux/theme.conf|' "$tmux_config"
else
    sed -i 's|^#\s*source-file\s.*colors.conf|source-file ~/.config/tmux/colors.conf|' "$tmux_config"
fi
tmux source-file ~/.config/tmux/colors.conf >/dev/null 2>&1 || true
