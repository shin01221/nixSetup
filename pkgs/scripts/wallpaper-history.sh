#!/usr/bin/env bash

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper-history"
history_file="$state_dir/history"
cursor_file="$state_dir/cursor"
max_entries=20

usage() {
    cat <<'EOF'
Usage: wallpaper-history.sh MODE

Modes:
  --record PATH...  Record one or more wallpapers (called by random_wall.sh)
  --prev            Set the previous wallpaper in history
  --next            Set the next wallpaper in history
  --pick            Pick a wallpaper from the history with fzf
  --list            Print the history (current marked with ">")
  --help            Show this help and exit
EOF
}

load_history() {
    history=()
    if [[ -f $history_file ]]; then
        mapfile -t history <"$history_file"
    fi

    cursor=0
    if [[ -f $cursor_file ]]; then
        read -r cursor <"$cursor_file"
    fi
    [[ $cursor =~ ^[0-9]+$ ]] || cursor=0

    local last=$(( ${#history[@]} - 1 ))
    (( cursor > last )) && cursor=$last
    (( cursor < 0 )) && cursor=0
}

save_history() {
    mkdir -p "$state_dir"
    printf '%s\n' "${history[@]}" >"$history_file"
    printf '%s\n' "$cursor" >"$cursor_file"
}

record() {
    load_history

    local path
    for path in "$@"; do
        [[ -n $path ]] || continue
        (( ${#history[@]} > 0 )) && [[ ${history[cursor]} == "$path" ]] && continue

        history=("${history[@]:0:cursor+1}")
        history+=("$path")
        cursor=$(( ${#history[@]} - 1 ))

        if (( ${#history[@]} > max_entries )); then
            local drop=$(( ${#history[@]} - max_entries ))
            history=("${history[@]:drop}")
            cursor=$(( cursor - drop ))
            (( cursor < 0 )) && cursor=0
        fi
    done

    save_history
}

prev() {
    load_history
    if (( ${#history[@]} == 0 )) || (( cursor == 0 )); then
        notify-send "Wallpaper history" "No previous wallpaper recorded"
        exit 1
    fi

    ((cursor--))
    save_history
    noctalia msg wallpaper-set "${history[cursor]}"
}

next() {
    load_history
    if (( ${#history[@]} == 0 )) || (( cursor >= ${#history[@]} - 1 )); then
        notify-send "Wallpaper history" "No next wallpaper recorded"
        exit 1
    fi

    ((cursor++))
    save_history
    noctalia msg wallpaper-set "${history[cursor]}"
}

list() {
    load_history
    local i
    for i in "${!history[@]}"; do
        if (( i == cursor )); then
            printf '> %s\n' "${history[i]}"
        else
            printf '  %s\n' "${history[i]}"
        fi
    done
}

pick() {
    load_history
    if (( ${#history[@]} == 0 )); then
        notify-send "Wallpaper history" "No wallpapers recorded yet"
        exit 1
    fi
    command -v fzf >/dev/null 2>&1 || {
        notify-send "Wallpaper history" "fzf not found"
        exit 1
    }

    local script_dir preview_helper preview_args=()
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
    if [[ -x $script_dir/fzf_preview.sh ]]; then
        preview_helper="$(printf '%q' "$script_dir")/fzf_preview.sh"
        preview_args=(--preview "$preview_helper {2}" --preview-window='right:60%:border:wrap')
    fi

    local selection idx path rest
    selection=$(
        local i
        for ((i = ${#history[@]} - 1; i >= 0; i--)); do
            printf '%s\t%s\t%s\n' "$i" "${history[i]}" "$(basename "${history[i]}")"
        done |
            fzf --delimiter=$'\t' --with-nth=3 \
                --prompt='Wallpapers> ' \
                --header='Enter: set wallpaper  |  Esc: cancel' \
                "${preview_args[@]}"
    ) || exit 0

    [[ -n $selection ]] || exit 0

    idx=${selection%%$'\t'*}
    rest=${selection#*$'\t'}
    path=${rest%%$'\t'*}
    [[ $idx =~ ^[0-9]+$ ]] || exit 0

    cursor=$idx
    save_history
    noctalia msg wallpaper-set "$path"
}

case ${1:-} in
--record)
    shift
    record "$@"
    ;;
--prev | --previous)
    prev
    ;;
--next)
    next
    ;;
--pick)
    pick
    ;;
--list)
    list
    ;;
--help | -h)
    usage
    ;;
*)
    usage >&2
    exit 1
    ;;
esac
