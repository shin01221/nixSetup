#!/usr/bin/env bash

# Get current wallpaper path from JSON
wallpaper_path=$(noctalia msg wallpaper-get)

# Get the directory containing the wallpapers
wallpaper_dir="$(dirname "$wallpaper_path")"

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
