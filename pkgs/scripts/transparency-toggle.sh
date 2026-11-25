#!/usr/bin/env bash
set -euo pipefail

noctaliaConf="$HOME/.config/noctalia/noctalia-config.toml"
niriOverride="$HOME/.config/niri/override.kdl"
umbrielOverride="$HOME/.config/umbriel/override.toml"

DEFAULT_WM="auto"

notify() {
    local summary="$1" body="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Transparency" -i "preferences-desktop-display" "$summary" "$body" || true
    elif command -v noctalia >/dev/null 2>&1; then
        noctalia msg notification-show "$summary" "$body" >/dev/null 2>&1 || true
    fi
}

detect_wm() {
    if [ -n "${NIRI_SOCKET:-}" ] || pgrep -x niri >/dev/null 2>&1; then
        printf 'niri\n'
    elif [ -n "${UMBRIEL_SOCKET:-}" ] ||
        pgrep -x umbriel >/dev/null 2>&1 ||
        pgrep -x .umbriel-wrappe >/dev/null 2>&1 ||
        pgrep -x start-umbriel >/dev/null 2>&1 ||
        [[ "${XDG_CURRENT_DESKTOP:-}" == *[Uu]mbriel* ]]; then
        printf 'umbriel\n'
    else
        printf 'unknown\n'
    fi
}

noctalia_set_opacity() {
    local bg="$1" capsule="$2"
    command -v noctalia >/dev/null 2>&1 || return 0

    local path
    for path in \
        bar.main.background_opacity \
        bar.bottom.background_opacity \
        dock.background_opacity \
        notification.background_opacity \
        osd.background_opacity; do
        noctalia msg config-set "$path" "$bg" >/dev/null 2>&1 || true
    done

    noctalia msg config-set bar.main.capsule_opacity "$capsule" >/dev/null 2>&1 || true

    [ -f "$noctaliaConf" ] || return 0
    while IFS= read -r widget; do
        [ -n "$widget" ] || continue
        noctalia msg config-set "widget.${widget}.capsule_opacity" "$capsule" >/dev/null 2>&1 || true
    done < <(awk '
    /^[[:space:]]*\[widget\./ {
      name = $0
      sub(/^[[:space:]]*\[widget\./, "", name)
      sub(/\][[:space:]]*$/, "", name)
      section = name
      next
    }
    /^[[:space:]]*\[/ { section = "" }
    /^[[:space:]]*capsule_opacity[[:space:]]*=/ && section != "" {
      print section
      section = ""
    }
  ' "$noctaliaConf")

    while IFS= read -r widget; do
        [ -n "$widget" ] || continue
        noctalia msg config-set "desktop_widgets.widget.${widget}.settings.background_opacity" "$bg" >/dev/null 2>&1 || true
    done < <(awk '
    /^[[:space:]]*\[desktop_widgets\.widget\.[^]]+\.settings\][[:space:]]*$/ {
      name = $0
      sub(/^[[:space:]]*\[desktop_widgets\.widget\./, "", name)
      sub(/\.settings\][[:space:]]*$/, "", name)
      section = name
      next
    }
    /^[[:space:]]*\[/ { section = "" }
    /^[[:space:]]*background_opacity[[:space:]]*=/ && section != "" {
      print section
      section = ""
    }
  ' "$noctaliaConf")
}

ensure_umbriel_override() {
    if [ ! -f "$umbrielOverride" ]; then
        cat >"$umbrielOverride" <<'EOF'
# Writable Umbriel overrides. Not managed by Home Manager.
# transparency-toggle.sh toggles the two include entries below.
# Blur settings live here so they can be changed live.

[include.optional]
files = [
  # "~/.config/umbriel/solid.toml",
  # "~/.config/umbriel/transparency.toml",
]

[appearance.blur]
enabled = true
optimized = true
passes = 4
radius = 5
noise = 0.06
saturation = 1.8

[[window_rule]]
blur = true
EOF
        return
    fi

    if ! rg -q 'solid\.toml' "$umbrielOverride" || ! rg -q 'transparency\.toml' "$umbrielOverride"; then
        notify "Transparency" "override.toml is missing the toggle entries."
        exit 1
    fi
}

toggle_niri() {
    if rg -q '^\s*//\s*include\s+"transparency\.kdl"' "$niriOverride"; then
        sd '^\s*//\s*include\s+"transparency\.kdl".*' 'include "transparency.kdl"' "$niriOverride"
        noctalia_set_opacity 1.00 1.00
        notify "Transparency off" "Niri windows and shell are opaque."
    else
        sd '^\s*include\s+"transparency\.kdl".*' '// include "transparency.kdl"' "$niriOverride"
        noctalia_set_opacity 0.95 0.50
        notify "Transparency on" "Niri windows and shell are translucent."
    fi
}

toggle_umbriel() {
    ensure_umbriel_override

    if rg -q '^\s*"~/.config/umbriel/transparency\.toml"' "$umbrielOverride"; then
        sd '^(\s*)("~/.config/umbriel/transparency\.toml".*)' '${1}# ${2}' "$umbrielOverride"
        sd '^(\s*)#\s*("~/.config/umbriel/solid\.toml".*)' '${1}${2}' "$umbrielOverride"
        noctalia_set_opacity 1.00 1.00
        notify "Transparency off" "Umbriel windows and shell are opaque."
    else
        sd '^(\s*)#\s*("~/.config/umbriel/transparency\.toml".*)' '${1}${2}' "$umbrielOverride"
        sd '^(\s*)("~/.config/umbriel/solid\.toml".*)' '${1}# ${2}' "$umbrielOverride"
        noctalia_set_opacity 0.95 0.50
        notify "Transparency on" "Umbriel windows and shell are translucent."
    fi
}

refresh_which_key() {
    local script
    script="$(dirname "$0")/which-key.sh"
    if [ ! -x "$script" ]; then
        script="$(command -v which-key.sh || true)"
    fi
    if [ -n "$script" ]; then
        "$script" "$wm" >/dev/null 2>&1 || true
    fi
}

wm="${1:-$DEFAULT_WM}"
if [ "$wm" = "auto" ]; then
    wm="$(detect_wm)"
fi

case "$wm" in
niri) toggle_niri ;;
umbriel) toggle_umbriel ;;
*)
    notify "Transparency" "No supported compositor detected."
    exit 1
    ;;
esac

refresh_which_key
