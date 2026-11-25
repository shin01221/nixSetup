#!/usr/bin/env bash

root="${WALLPAPER_ROOT:-$HOME/Pictures}"
root="${root%/}"
[[ -d $root ]] && root="$(readlink -f "$root")"
script_path="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)/$(basename "${BASH_SOURCE[0]:-$0}")"
script_dir="$(dirname "$script_path")"

usage() {
    cat <<'EOF'
Usage: wallpaper_dir_set.sh [--preview DIR]

Pick a directory containing wallpapers under ~/Pictures and set a random
wallpaper from it. The picker lists directories that contain images directly.
EOF
}

preview_dir() {
    local dir="$1"
    local image
    image=$(find "$dir" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -print -quit 2>/dev/null)

    if [[ -z $image ]]; then
        printf 'No images directly in %s\n' "$dir"
        return
    fi

    if [[ -x $script_dir/fzf_preview.sh ]]; then
        "$script_dir/fzf_preview.sh" "$image"
    else
        printf '%s\n' "$image"
    fi
}

pick_dir() {
    if [[ ! -d $root ]]; then
        notify-send "Wallpaper directory" "Not found: $root"
        exit 1
    fi
    command -v fzf >/dev/null 2>&1 || {
        notify-send "Wallpaper directory" "fzf not found"
        exit 1
    }

    local preview_cmd selection rel dir count listing
    preview_cmd="$(printf '%q' "$script_path") --preview {2}"

    listing=$(
        find "$root" \
            \( -type d \( -iname 'screenshots' -o -iname 'pfp' -o -iname 'wayscrollshot' \) -prune \) -o \
            -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            -printf '%h\n' 2>/dev/null |
            sort | uniq -c |
            while read -r count dir; do
                rel="${dir#"$root"/}"
                [[ $rel == "$dir" ]] && rel="."
                printf '%s\t%s\n' "$rel [$count]" "$dir"
            done
    )

    if [[ -z $listing ]]; then
        notify-send "Wallpaper directory" "No images found under $root"
        exit 1
    fi

    selection=$(printf '%s\n' "$listing" | fzf --delimiter=$'\t' --with-nth=1 \
        --prompt='Wallpaper dir> ' \
        --header='Enter: set random wallpaper from directory  |  Esc: cancel' \
        --preview "$preview_cmd" \
        --preview-window='right:55%:border:wrap') || exit 0

    [[ -n $selection ]] || exit 0

    dir=${selection#*$'\t'}

    local random_script="$script_dir/random_wall.sh"
    if [[ ! -x $random_script ]]; then
        notify-send "Wallpaper directory" "random_wall.sh not found"
        exit 1
    fi

    "$random_script" "$dir"
}

case ${1:-} in
--preview)
    preview_dir "$2"
    ;;
--help | -h)
    usage
    ;;
"")
    pick_dir
    ;;
*)
    usage >&2
    exit 1
    ;;
esac
