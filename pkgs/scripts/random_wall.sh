#!/usr/bin/env bash

# Get current wallpaper path from JSON
wallpaper_path=$(noctalia msg wallpaper-get)

# Use the requested directory, or the directory of the current wallpaper
wallpaper_dir="${1:-$(dirname "$wallpaper_path")}"

if [[ ! -d $wallpaper_dir ]]; then
    echo "Error: Wallpaper directory not found: $wallpaper_dir"
    exit 1
fi

# Find all images directly in this directory (skip subdirectories like "fav")
mapfile -t images < <(find "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | grep -vF -- "$wallpaper_path")

# If no other images are found, exit
if [[ ${#images[@]} -eq 0 ]]; then
    echo "Error: No alternative wallpapers found in $wallpaper_dir"
    exit 1
fi

# Pick a random image from the remaining ones
random_image="$(printf "%s\n" "${images[@]}" | shuf -n 1)"

noctalia msg wallpaper-set "$random_image"

history_script="$(dirname "${BASH_SOURCE[0]:-$0}")/wallpaper-history.sh"
[[ -x $history_script ]] && "$history_script" --record "$wallpaper_path" "$random_image"
