#!/usr/bin/env bash

config="$HOME/.config/wlr-which-key/niri.yaml"
json="$HOME/.config/wlr-which-key/colors.json"

bg=$(jq -r '.background' "$json")
fg=$(jq -r '.color' "$json")
border=$(jq -r '.border' "$json")

sd '^(color: ).*' "\$1\"${fg}\"" "$config"
sd '^(border: ).*' "\$1\"${border}\"" "$config"
sd '^(background: ).*' "\$1\"${bg}\"" "$config"
