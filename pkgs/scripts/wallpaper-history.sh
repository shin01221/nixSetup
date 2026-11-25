#!/usr/bin/env bash

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper-history"
db_file="$state_dir/wallpapers.db"
legacy_history="$state_dir/history"
legacy_cursor="$state_dir/cursor"
max_entries=20
pick_limit=25

usage() {
    cat <<'EOF'
Usage: wallpaper-history.sh MODE

Modes:
  --record PATH...  Record one or more wallpapers (called by random_wall.sh)
  --prev            Set the previous wallpaper in history
  --next            Set the next wallpaper in history
  --pick            Pick from up to 25 images in the current wallpaper's directory
  --list            Print the history (current marked with ">")
  --help            Show this help and exit
EOF
}

sql() {
    sqlite3 -batch -noheader -separator $'\t' "$db_file" "$@"
}

sql_escape() {
    printf '%s' "${1//\'/\'\'}"
}

set_cursor() {
    sql "INSERT INTO meta(key, value) VALUES ('cursor_id', '$1')
         ON CONFLICT(key) DO UPDATE SET value = excluded.value;"
}

get_cursor() {
    sql "SELECT value FROM meta WHERE key = 'cursor_id';"
}

record_path() {
    local path="$1" used_at="${2:-$(date +%s)}"
    local dir esc_path esc_dir

    path="$(realpath -m -- "$path")"
    dir="$(dirname -- "$path")"
    esc_path=$(sql_escape "$path")
    esc_dir=$(sql_escape "$dir")

    sql <<SQL
BEGIN;
INSERT INTO images(path, dir, last_used, use_count)
VALUES ('$esc_path', '$esc_dir', $used_at, 1)
ON CONFLICT(path) DO UPDATE SET
    last_used = excluded.last_used,
    use_count = use_count + 1;
INSERT INTO history(path, used_at) VALUES ('$esc_path', $used_at);
INSERT INTO meta(key, value) VALUES ('cursor_id', (SELECT MAX(id) FROM history))
    ON CONFLICT(key) DO UPDATE SET value = excluded.value;
COMMIT;
SQL
}

migrate_legacy() {
    [[ -f $legacy_history ]] || return 0

    local count
    count=$(sql "SELECT COUNT(*) FROM history;")
    [[ ${count:-0} == 0 ]] || return 0

    local path
    while IFS= read -r path; do
        [[ -n $path ]] || continue
        record_path "$path" 0
    done <"$legacy_history"

    local cursor id
    cursor=0
    if [[ -f $legacy_cursor ]]; then
        read -r cursor <"$legacy_cursor"
    fi
    [[ $cursor =~ ^[0-9]+$ ]] || cursor=0

    id=$(sql "SELECT id FROM history ORDER BY id ASC LIMIT 1 OFFSET $cursor;")
    if [[ -n $id ]]; then
        set_cursor "$id"
    else
        set_cursor "$(sql "SELECT MAX(id) FROM history;")"
    fi
}

init_db() {
    mkdir -p "$state_dir"
    command -v sqlite3 >/dev/null 2>&1 || {
        notify-send "Wallpaper history" "sqlite3 not found"
        exit 1
    }

    sqlite3 -batch "$db_file" >/dev/null <<'SQL'
PRAGMA journal_mode=WAL;
CREATE TABLE IF NOT EXISTS images (
    path TEXT PRIMARY KEY,
    dir TEXT NOT NULL,
    last_used INTEGER NOT NULL DEFAULT 0,
    use_count INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_images_dir_last_used ON images(dir, last_used DESC);
CREATE TABLE IF NOT EXISTS history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL,
    used_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS meta (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
SQL

    migrate_legacy
}

trim_history() {
    sql "DELETE FROM history
         WHERE id NOT IN (
             SELECT id FROM history ORDER BY id DESC LIMIT $max_entries
         );
         UPDATE meta
         SET value = (SELECT MAX(id) FROM history)
         WHERE key = 'cursor_id'
           AND CAST(value AS INTEGER) NOT IN (SELECT id FROM history);"
}

record() {
    init_db

    local path last last_id esc_path
    for path in "$@"; do
        [[ -n $path ]] || continue
        path="$(realpath -m -- "$path")"

        last=$(sql "SELECT path FROM history ORDER BY id DESC LIMIT 1;")
        if [[ $last == "$path" ]]; then
            last_id=$(sql "SELECT id FROM history ORDER BY id DESC LIMIT 1;")
            esc_path=$(sql_escape "$path")
            sql "UPDATE images
                 SET last_used = strftime('%s','now'), use_count = use_count + 1
                 WHERE path = '$esc_path';"
            set_cursor "$last_id"
            continue
        fi

        record_path "$path"
    done

    trim_history
}

prev() {
    init_db

    local cursor prev_id path esc_path
    cursor=$(get_cursor)
    [[ $cursor =~ ^[0-9]+$ ]] || cursor=0

    prev_id=$(sql "SELECT id FROM history WHERE id < $cursor ORDER BY id DESC LIMIT 1;")
    if [[ -z $prev_id ]]; then
        notify-send "Wallpaper history" "No previous wallpaper recorded"
        exit 1
    fi

    set_cursor "$prev_id"
    path=$(sql "SELECT path FROM history WHERE id = $prev_id;")
    esc_path=$(sql_escape "$path")
    sql "UPDATE images
         SET last_used = strftime('%s','now'), use_count = use_count + 1
         WHERE path = '$esc_path';"
    noctalia msg wallpaper-set "$path"
}

next() {
    init_db

    local cursor next_id path esc_path
    cursor=$(get_cursor)
    [[ $cursor =~ ^[0-9]+$ ]] || cursor=0

    next_id=$(sql "SELECT id FROM history WHERE id > $cursor ORDER BY id ASC LIMIT 1;")
    if [[ -z $next_id ]]; then
        notify-send "Wallpaper history" "No next wallpaper recorded"
        exit 1
    fi

    set_cursor "$next_id"
    path=$(sql "SELECT path FROM history WHERE id = $next_id;")
    esc_path=$(sql_escape "$path")
    sql "UPDATE images
         SET last_used = strftime('%s','now'), use_count = use_count + 1
         WHERE path = '$esc_path';"
    noctalia msg wallpaper-set "$path"
}

list() {
    init_db

    local cursor id path
    cursor=$(get_cursor)

    while IFS=$'\t' read -r id path; do
        if [[ $id == "$cursor" ]]; then
            printf '> %s\n' "$path"
        else
            printf '  %s\n' "$path"
        fi
    done < <(sql "SELECT id, path FROM history ORDER BY id ASC;")
}

scan_dir() {
    local dir="$1"
    local esc_dir path esc_path

    dir="$(realpath -m -- "$dir")"
    esc_dir=$(sql_escape "$dir")

    {
        printf 'BEGIN;\n'
        while IFS= read -r -d '' path; do
            esc_path=$(sql_escape "$path")
            printf "INSERT INTO images(path, dir, last_used, use_count) VALUES ('%s', '%s', 0, 0) ON CONFLICT(path) DO NOTHING;\n" \
                "$esc_path" "$esc_dir"
        done < <(find "$dir" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
            -print0 2>/dev/null)
        printf 'COMMIT;\n'
    } | sql
}

pick() {
    init_db

    command -v fzf >/dev/null 2>&1 || {
        notify-send "Wallpaper history" "fzf not found"
        exit 1
    }

    local current current_dir esc_dir esc_current listing
    current=$(noctalia msg wallpaper-get 2>/dev/null | head -n1)
    if [[ -z $current ]]; then
        current=$(sql "SELECT path FROM history ORDER BY id DESC LIMIT 1;")
    fi
    if [[ -z $current ]]; then
        notify-send "Wallpaper history" "No current wallpaper found"
        exit 1
    fi

    current="$(realpath -m -- "$current")"
    current_dir="$(dirname -- "$current")"
    if [[ ! -d $current_dir ]]; then
        notify-send "Wallpaper history" "Directory not found: $current_dir"
        exit 1
    fi

    scan_dir "$current_dir"

    esc_dir=$(sql_escape "$current_dir")
    esc_current=$(sql_escape "$current")
    sql "INSERT INTO images(path, dir, last_used, use_count)
         VALUES ('$esc_current', '$esc_dir', 0, 0)
         ON CONFLICT(path) DO NOTHING;"

    listing=$(sql "SELECT path FROM images
                   WHERE dir = '$esc_dir'
                   ORDER BY (path = '$esc_current') DESC, RANDOM()
                   LIMIT $pick_limit;")
    if [[ -z $listing ]]; then
        notify-send "Wallpaper history" "No images found in $current_dir"
        exit 1
    fi

    local script_dir preview_helper preview_args=()
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
    if [[ -x $script_dir/fzf_preview.sh ]]; then
        preview_helper="$(printf '%q' "$script_dir")/fzf_preview.sh"
        preview_args=(--preview "$preview_helper {1}" --preview-window='right:60%:border:wrap')
    fi

    local selection path marker
    selection=$(
        while IFS= read -r path; do
            marker=" "
            [[ $path == "$current" ]] && marker="*"
            printf '%s\t%s %s\n' "$path" "$marker" "$(basename -- "$path")"
        done <<<"$listing" |
            fzf --delimiter=$'\t' --with-nth=2 \
                --prompt='Wallpapers> ' \
                --header="Dir: $current_dir  |  Enter: set wallpaper  |  Esc: cancel" \
                "${preview_args[@]}"
    ) || exit 0

    [[ -n $selection ]] || exit 0
    path=${selection%%$'\t'*}
    [[ -n $path ]] || exit 0

    noctalia msg wallpaper-set "$path"
    record "$path"
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
