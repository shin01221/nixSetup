#!/usr/bin/env bash

current=$(niri msg keyboard-layouts | grep -oP '^\s*\*\s+\d+\s+\K.*')
[[ "$current" != "English (US)" ]] && niri msg action switch-layout next
