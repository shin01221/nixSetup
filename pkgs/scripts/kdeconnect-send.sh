#!/usr/bin/env bash

die() {
    echo "Error: $*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Usage: kdeconnect-send.sh [OPTIONS] [COUNT] [DIR]

Pick recently modified files with recent_files.sh and share them to a paired
KDE Connect device via kdeconnect-cli.

Options:
  -d, --device ID   Device id to send to (default: the only paired and
                    reachable device, or an fzf picker when there are several)
  -h, --help        Show this help and exit

Arguments:
  COUNT  Number of recent files to list (default: 20)
  DIR    Directory to scan (default: ~/Downloads)

Environment:
  KDE_CONNECT_DEVICE  Default device id when --device is not given

Examples:
  kdeconnect-send.sh
  kdeconnect-send.sh 50 ~/Pictures
  kdeconnect-send.sh --device 3787d2a82ec74066a5ee96a29d9c3b87 10 ~/Documents
EOF
    exit 0
}

command -v kdeconnect-cli >/dev/null 2>&1 || die "kdeconnect-cli not found"

device="${KDE_CONNECT_DEVICE:-}"
positional=()
while [ $# -gt 0 ]; do
    case "$1" in
    -d | --device)
        [ $# -ge 2 ] || die "Missing value for $1"
        device="$2"
        shift 2
        ;;
    --device=*)
        device="${1#*=}"
        shift
        ;;
    -h | --help) usage ;;
    --)
        shift
        positional+=("$@")
        break
        ;;
    -*) die "Unknown option: $1 (see --help)" ;;
    *)
        positional+=("$1")
        shift
        ;;
    esac
done

count="${positional[0]:-20}"
dir="${positional[1]:-$HOME/Downloads}"

# Resolve the picker next to this script, not via PATH, so a direct run from
# the repo uses the matching recent_files.sh even when the installed copy on
# PATH is stale. Fall back to PATH for a standalone copy of this script.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
picker="$script_dir/recent_files.sh"
if [ ! -x "$picker" ]; then
    picker=$(command -v recent_files.sh 2>/dev/null || true)
fi
[ -n "$picker" ] && [ -x "$picker" ] || die "recent_files.sh not found (needed as the picker)"

if [ -z "$device" ]; then
    mapfile -t devices < <(kdeconnect-cli -a --id-name-only 2>/dev/null)
    [ "${#devices[@]}" -eq 0 ] && die "No paired and reachable KDE Connect devices"
    if [ "${#devices[@]}" -eq 1 ]; then
        device="${devices[0]%% *}"
    else
        command -v fzf >/dev/null 2>&1 || die "fzf not found (required to choose between devices)"
        choice=$(printf '%s\n' "${devices[@]}" | fzf --prompt="KDE Connect device> " --height=40%)
        [ -z "$choice" ] && exit 0
        device="${choice%% *}"
    fi
fi

mapfile -t files < <("$picker" --print "$count" "$dir")
[ "${#files[@]}" -eq 0 ] && exit 0

sent=0
failed=0
for f in "${files[@]}"; do
    if kdeconnect-cli -d "$device" --share "$f"; then
        printf 'Sent %s\n' "$f"
        sent=$((sent + 1))
    else
        printf 'Failed to send %s\n' "$f" >&2
        failed=$((failed + 1))
    fi
done

printf 'Sent %d file(s), %d failed\n' "$sent" "$failed" >&2
[ "$failed" -eq 0 ]
