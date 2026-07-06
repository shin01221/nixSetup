#!/usr/bin/env bash

workflows_dir="$HOME/.config/hypr/custom/workflows/"
hypr_config="$HOME/.config/hypr/custom/general.conf"
# fzf_picker=$(command ls ~/.config/hypr/custom/workflows/ | cut -d "." -f 1 | fzf)
illogical_conf="$HOME/.config/illogical-impulse/config.json"
noctalia_conf="$HOME/.config/noctalia/settings.json"
foot_conf="$HOME/.config/foot/transparency.conf"

case "$1" in
default)
    sed -i 's|source\s*=\s*workflows.*|source=workflows/default.conf|' "$hypr_config"
    sed -i 's/^alpha.*/alpha=.95/' "$foot_conf"
    jq -r '.ui.panelBackgroundOpacity = 0.90' "$noctalia_conf" >"$noctalia_conf.tmp" && mv "$noctalia_conf.tmp" "$noctalia_conf"
    jq '.appearance.transparency.enable = true' "$illogical_conf" >"$illogical_conf.tmp" && mv "$illogical_conf.tmp" "$illogical_conf"
    ;;
powersaver)
    sed -i 's|source\s*=\s*workflows.*|source=workflows/powersaver.conf|' "$hypr_config"
    jq '.appearance.transparency.enable = false' "$illogical_conf" >"$illogical_conf.tmp" && mv "$illogical_conf.tmp" "$illogical_conf"
    jq -r '.ui.panelBackgroundOpacity = 1.00' "$noctalia_conf" >"$noctalia_conf.tmp" && mv "$noctalia_conf.tmp" "$noctalia_conf"
    sed -i 's/^alpha.*/alpha=1/' "$foot_conf"
    ;;
snappy)
    sed -i 's|source\s*=\s*workflows.*|source=workflows/snappy.conf|' "$hypr_config"
    sed -i 's/^alpha.*/alpha=.95/' "$foot_conf"
    jq -r '.ui.panelBackgroundOpacity = 0.90' "$noctalia_conf" >"$noctalia_conf.tmp" && mv "$noctalia_conf.tmp" "$noctalia_conf"
    jq '.appearance.transparency.enable = true' "$illogical_conf" >"$illogical_conf.tmp" && mv "$illogical_conf.tmp" "$illogical_conf"
    ;;
*)
    echo -e "avillable workspaces is \ndefault\npowersaver\nsnappy "
    ;;
esac
