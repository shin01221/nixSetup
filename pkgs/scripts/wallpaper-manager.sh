#!/usr/bin/env bash
source "$HOME/.local/bin/functions.sh"

mode=$1

case $mode in

--delete)
    wall_delete
    ;;
--help)
    echo "--fav-manage to remove or add a current wallpaper to favourites"
    echo "--delete to delete the current wallpaper"
    ;;
esac
