#!/usr/bin/env bash

if systemctl --user --quiet is-active mpd.service; then
	# Stop both services
	systemctl --user stop mpd-mpris.service
	systemctl --user stop mpd.service
	notify-send "MPD stopped (with MPRIS bridge)"
else
	# Start both services
	systemctl --user start mpd.service
	systemctl --user start mpd-mpris.service
	notify-send "MPD started (with MPRIS bridge)"
fi
