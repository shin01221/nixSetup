#!/usr/bin/env bash

die() {
    echo "Error: $*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Usage: recent_files.sh [OPTIONS] [COUNT] [DIR]

List recently modified files in a directory and pick with fzf.

Options:
  --save       Copy selected paths to clipboard (wl-copy)
  --print      Print selected paths to stdout
  --no-picker  Skip fzf, print N most recent files directly
  --help       Show this help and exit

Arguments:
  COUNT  Number of recent files to list (default: 5)
  DIR    Directory to scan (default: current directory)

Examples:
  recent_files.sh
  recent_files.sh 10 ~/Downloads
  recent_files.sh --print 5 ~/Pictures
  recent_files.sh --save 3 ~/Documents
  recent_files.sh --no-picker 8 ~/Videos
EOF
    exit 0
}

save_mode=false
print_mode=false
no_picker=false
positional=()
for arg in "$@"; do
    case "$arg" in
    --save) save_mode=true ;;
    --print) print_mode=true ;;
    --no-picker) no_picker=true ;;
    --help) usage ;;
    *) positional+=("$arg") ;;
    esac
done
set -- "${positional[@]}"

count="${1:-5}"
if [[ "$count" =~ ^[0-9]+$ ]]; then
    shift
else
    count=5
fi

search_dir="${1:-.}"
search_dir="${search_dir/#\~/$HOME}"
search_dir="$(realpath -m "$search_dir" 2>/dev/null || realpath "$search_dir" 2>/dev/null || echo "$search_dir")"

[ -d "$search_dir" ] || die "'$search_dir' is not a directory"

if ! $print_mode && ! $save_mode && ! $no_picker; then
    command -v gio >/dev/null 2>&1 || die "gio not found (required for default open mode)"
fi
$save_mode && ! command -v wl-copy >/dev/null 2>&1 && die "wl-copy not found (required for --save)"

skip_names=('.git' '.github' 'node_modules' '__pycache__'
    '.cache' '.npm' '.yarn' '.pnpm-store'
    '*.pyc' '*.swp' '*.swx' '*.swo'
    '.DS_Store' 'Thumbs.db')
find_skip=()
for n in "${skip_names[@]}"; do find_skip+=(-not -name "$n"); done
files=$(find "$search_dir" -mindepth 1 -maxdepth 1 \
    -not -name "$(basename "$0")" \
    "${find_skip[@]}" \
    -printf '%T+ %p\n' 2>/dev/null |
    sort -r |
    head -n "$count" |
    cut -d' ' -f2-)

[ -z "$files" ] && die "No files found in '$search_dir'"

if $no_picker; then
    printf '%s\n' "$files"
    exit 0
fi

command -v fzf >/dev/null 2>&1 || die "fzf not found (required for interactive picker)"

[ -t 1 ] && clear

selected=$(printf '%s\n' "$files" |
    while IFS= read -r fullpath; do
        printf "%s\n" "${fullpath#$search_dir/}"
    done |
    fzf --multi \
        --prompt="Recent files> " \
        --height=80% \
        --preview="fzf_preview.sh $(printf '%q' "$search_dir")/{}" \
        --preview-window='right:70%:border:wrap')

[ -z "$selected" ] && exit 0

if $print_mode; then
    while IFS= read -r sel; do
        printf "'%s'\n" "$search_dir/$sel"
    done <<< "$selected"
elif $save_mode; then
    paths=$(printf '"%s"' "$search_dir/$selected" | paste -sd,)
    printf '%s' "$paths" | wl-copy
else
    while IFS= read -r sel; do
        gio open "$search_dir/$sel"
    done <<<"$selected"
fi
