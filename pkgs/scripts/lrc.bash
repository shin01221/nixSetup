#!/usr/bin/env bash

# players=$(playerctl --list-all)
statusSpotify=$(playerctl status --player spotify 2>/dev/null)
statusMpd=$(playerctl status --player mpd 2>/dev/null)

if [[ $statusSpotify == "Playing" ]]; then
    lrc_tty --raw --player spotify
fi
if [[ $statusMpd == "Playing" ]]; then
    lrc_tty --raw --player mpd
fi
