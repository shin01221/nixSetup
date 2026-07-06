#!/usr/bin/env bash

case "$1" in
rmpc)
    env NO_TMUX=1 kitty --app-id=rmpc -e rmpc &
    ;;
*)
    env NO_TMUX=1 foot --app-id=lrc -e lrc_tty --lines 12 --dim &
    ;;
esac
