#!/usr/bin/env bash

SENTENCES=(
    "Study you are in egypt"
    "You can't afford being unemployed forever"
    "don't waste your time"
    "Egypt won't show mercy"
    "Don't goone please it's a very temporary pleasure"
)

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/cycle-notify-idx"

if [[ -f "$STATE_FILE" ]]; then
    idx=$(<"$STATE_FILE")
    idx=$(((idx + 1) % ${#SENTENCES[@]}))
else
    idx=0
fi

echo "$idx" >"$STATE_FILE"

notify-send "${SENTENCES[$idx]}"
