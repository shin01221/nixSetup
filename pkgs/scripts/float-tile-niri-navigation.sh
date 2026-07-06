#!/usr/bin/env bash

set -euo pipefail

direction="${1:-}"

if [[ "$direction" != "left" && "$direction" != "right" ]]; then
    echo "Usage: $0 left|right"
    exit 1
fi

is_floating="$(niri msg -j focused-window | jq -r '.is_floating')"

if [[ "$is_floating" == "true" ]]; then
    niri msg action switch-focus-between-floating-and-tiling
else
    niri msg action focus-column-"$direction"
fi
