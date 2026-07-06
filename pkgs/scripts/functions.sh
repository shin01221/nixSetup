#!/usr/bin/env bash

# Vars
path=$(noctalia msg wallpaper-get)
base_homework="/Media/Pictures/homework"
base_fav="/Media/Pictures/fav"
base_wallpapers="/Media/Pictures/Wallpapers"

#Functions
move_by_dimensions() {
    local img="$1"
    local vdir="$2"
    local hdir="$3"

    dimensions=$(identify -format "%w %h" "$img" 2>/dev/null) || return
    [ -z "$dimensions" ] && return

    width=$(echo "$dimensions" | awk '{print $1}')
    height=$(echo "$dimensions" | awk '{print $2}')

    if [ "$height" -gt "$width" ]; then
        mv "$img" "$vdir/"
    elif [ "$width" -gt "$height" ]; then
        mv "$img" "$hdir/"
    else
        mv "$img" "$vdir/" # fallback: treat square as vertical
    fi
}

wall_delete() {
    rm "$path"
}
