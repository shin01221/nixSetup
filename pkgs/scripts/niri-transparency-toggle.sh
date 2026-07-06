#!/usr/bin/env bash

noctaliaConf="$HOME/.config/noctalia"
niriConf="$HOME/.config/niri/override.kdl"

if rg -q '\/\/\s*.*"transparency.*' "$niriConf"; then
    sd '//\s+.*transparency.*' 'include "transparency.kdl"' "$niriConf"
    sd 'background_opacity.*' 'background_opacity = 1.00' "$noctaliaConf/noctalia-config.toml"
    sd 'capsule_opacity.*' 'capsule_opacity = 1.00' "$noctaliaConf/noctalia-config.toml"
else
    sd '.*transparency.*' '// include "transparency.kdl"' "$niriConf"
    sd 'background_opacity.*' 'background_opacity = 0.92' "$noctaliaConf/noctalia-config.toml"
    sd 'capsule_opacity.*' 'capsule_opacity = 0.50' "$noctaliaConf/noctalia-config.toml"
fi
