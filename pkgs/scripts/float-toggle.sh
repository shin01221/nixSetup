#!/usr/bin/env bash

floating=$(hyprctl activewindow -j | jq -r '.floating')

if [ "$floating" = "false" ]; then
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact 60% 70%
    hyprctl dispatch centerwindow
else
    hyprctl dispatch togglefloating
fi
