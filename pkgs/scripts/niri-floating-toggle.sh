#!/usr/bin/env bash

# read state
is_floating=$(niri msg -j focused-window | jq -r '.is_floating')

if [[ "$is_floating" == "false" ]]; then

    # toggle floating
    niri msg action toggle-window-floating
    sleep 0.09

    # apply floating size
    niri msg action set-window-width 60%
    niri msg action set-window-height 70%
    sleep 0.05
    niri msg action center-window

else
    niri msg action toggle-window-floating
fi
