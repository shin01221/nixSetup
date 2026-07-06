#!/usr/bin/env bash

ss -tulpnH | awk '{split($5,a,":"); print $1, a[length(a)]}' | sort | uniq | fzf | xargs sudo fuser -n 2>/dev/null | xargs ps -o comm=
