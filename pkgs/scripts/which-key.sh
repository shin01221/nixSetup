#!/usr/bin/env bash
set -euo pipefail

json="$HOME/.config/wlr-which-key/colors.json"
umbrielOverride="$HOME/.config/umbriel/override.toml"

detect_wm() {
    if [ -n "${NIRI_SOCKET:-}" ] || pgrep -x niri >/dev/null 2>&1; then
        printf 'niri\n'
    elif [ -n "${UMBRIEL_SOCKET:-}" ] ||
        pgrep -x umbriel >/dev/null 2>&1 ||
        pgrep -x .umbriel-wrappe >/dev/null 2>&1 ||
        pgrep -x start-umbriel >/dev/null 2>&1 ||
        [[ "${XDG_CURRENT_DESKTOP:-}" == *[Uu]mbriel* ]]; then
        printf 'umbriel\n'
    fi
}

umbriel_transparency_enabled() {
    [ -f "$umbrielOverride" ] &&
        rg -q '^\s*"~/.config/umbriel/transparency\.toml"' "$umbrielOverride"
}

opaque_hex() {
    local color="$1"
    if [[ "$color" =~ ^#[0-9a-fA-F]{8}$ ]]; then
        printf '%s' "${color:0:7}"
    else
        printf '%s' "$color"
    fi
}

wm="${1:-$(detect_wm)}"

case "$wm" in
niri) configs=("$HOME/.config/wlr-which-key/niri.yaml") ;;
umbriel) configs=("$HOME/.config/wlr-which-key/umbriel.yaml") ;;
*) configs=(
    "$HOME/.config/wlr-which-key/niri.yaml"
    "$HOME/.config/wlr-which-key/umbriel.yaml"
) ;;
esac

[ -f "$json" ] || exit 0

bg=$(jq -r '.background' "$json")
fg=$(jq -r '.color' "$json")
border=$(jq -r '.border' "$json")

for config in "${configs[@]}"; do
    [ -f "$config" ] || continue

    bg_value="$(opaque_hex "$bg")"
    if [[ "$config" == *"/umbriel.yaml" ]] &&
        umbriel_transparency_enabled &&
        [[ "$bg_value" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        bg_value="${bg_value}e6"
    fi

    sd '^(color: ).*' "\$1\"${fg}\"" "$config"
    sd '^(border: ).*' "\$1\"${border}\"" "$config"
    sd '^(background: ).*' "\$1\"${bg_value}\"" "$config"
done
