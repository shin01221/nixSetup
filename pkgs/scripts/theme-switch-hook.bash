#!/usr/bin/env bash

# settings=$HOME/.config/noctalia/settings.json
# matugen_conf=$HOME/.config/noctalia/user-templates.toml
auto_colors=$(noctalia msg color-scheme-get | cut -d ' ' -f 1)
theme=$(noctalia msg color-scheme-get | cut -d ' ' -f 2)
mode=$(noctalia msg theme-mode-get)
starship_configs=$HOME/.config/starship
tmux_themes=$HOME/.config/tmux/themes
tmux_config=$HOME/.config/tmux/tmux.conf
themes_arr=("Ayu" "Gruvbox" "Eldritch" "Everforest" "GruvboxAlt" "Kanagawa" "Miasma" "Monochrome" "Noctalia" "Nord" "Rose Pine" "Tokyo Night Moon" "Lilac AMOLED" "Occult Umbral" "One" "Oxide" "Vesper")

if [[ $auto_colors = wallpaper ]]; then
    exit
fi

if rg -q '^\s*source-file .*colors.conf' "$tmux_config" && rg -q '^#\s*source-file .*theme.conf' "$tmux_config"; then
    sed -i 's|^\s*source-file\s.*colors.conf|#source-file ~/.config/tmux/colors.conf|' "$tmux_config"
    sed -i 's|^#\s*source-file\s.*theme.conf|source-file ~/.config/tmux/theme.conf|' "$tmux_config"
else
    sed -i 's|^#\s*source-file\s.*theme.conf|source-file ~/.config/tmux/theme.conf|' "$tmux_config"
fi
apply_theme() {
    local theme_name=$1
    cp "$starship_configs/starship.toml-$theme_name-$mode" "$HOME/.config/starship.toml"
    cp "$tmux_themes/$theme_name-$mode.conf" "$HOME/.config/tmux/theme.conf"
}
case "$theme" in
"${themes_arr[0]}")
    apply_theme ayu
    ;;
"${themes_arr[1]}")
    apply_theme gruvbox
    ;;
"${themes_arr[2]}")
    apply_theme elderich
    ;;
"${themes_arr[3]}")
    apply_theme everforest
    ;;
"${themes_arr[4]}")
    apply_theme gruvboxalto
    ;;
"${themes_arr[5]}")
    apply_theme kanagwa
    ;;
"${themes_arr[6]}")
    apply_theme miasma
    ;;
"${themes_arr[7]}")
    apply_theme monochrome
    ;;
"${themes_arr[8]}")
    apply_theme noctalia
    ;;
"${themes_arr[9]}")
    apply_theme nord
    ;;
"${themes_arr[10]}")
    apply_theme rosepine
    ;;
"${themes_arr[11]}")
    apply_theme tokyounightmoon
    ;;
"${themes_arr[12]}")
    apply_theme lilac
    ;;
"${themes_arr[13]}")
    apply_theme occult
    ;;
"${themes_arr[14]}")
    apply_theme one
    ;;
"${themes_arr[15]}")
    apply_theme oxide
    ;;
"${themes_arr[16]}")
    apply_theme vesper
    ;;
esac

tmux source-file ~/.config/tmux/theme.conf >/dev/null 2>&1 || true
