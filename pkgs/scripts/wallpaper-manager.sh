#!/usr/bin/env bash
source "$(dirname "$0")/functions.sh"

mode=$1

case $mode in

--delete)
    if wall_delete; then
        notify-send "Wallpaper deleted 🗑️" "Removed $(basename "$path")"
    fi
    ;;
--help)
    echo "--fav-manage to remove or add a current wallpaper to favourites"
    echo "--delete to delete the current wallpaper"
    ;;
esac
