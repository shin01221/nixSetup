function _fzf_hex_to_ansi -a hex
    set -l h (string replace "#" "" $hex)
    set -l r (printf "%d" 0x(string sub -s 1 -l 2 $h))
    set -l g (printf "%d" 0x(string sub -s 3 -l 2 $h))
    set -l b (printf "%d" 0x(string sub -s 5 -l 2 $h))
    echo "38;2;$r;$g;$b"
end

set -gx LS_COLORS "\
di=(_fzf_hex_to_ansi {{colors.secondary.default.hex}}):\
fi=(_fzf_hex_to_ansi {{colors.on_surface.default.hex}}):\
ln=(_fzf_hex_to_ansi {{colors.tertiary.default.hex}}):\
or=(_fzf_hex_to_ansi {{colors.error.default.hex}}):\
ex=(_fzf_hex_to_ansi {{colors.primary.default.hex}}):\
bd=(_fzf_hex_to_ansi {{colors.primary_fixed_dim.default.hex}}):\
cd=(_fzf_hex_to_ansi {{colors.primary_fixed_dim.default.hex}}):\
pi=(_fzf_hex_to_ansi {{colors.tertiary_fixed_dim.default.hex}}):\
so=(_fzf_hex_to_ansi {{colors.tertiary_fixed_dim.default.hex}}):\
st=(_fzf_hex_to_ansi {{colors.tertiary_fixed_dim.default.hex}}):\
*.tar=(_fzf_hex_to_ansi {{colors.inverse_primary.default.hex}}):\
*.tgz=(_fzf_hex_to_ansi {{colors.inverse_primary.default.hex}}):\
*.zip=(_fzf_hex_to_ansi {{colors.inverse_primary.default.hex}}):\
*.jpg=(_fzf_hex_to_ansi {{colors.secondary_fixed_dim.default.hex}}):\
*.png=(_fzf_hex_to_ansi {{colors.secondary_fixed_dim.default.hex}}):\
*.mp3=(_fzf_hex_to_ansi {{colors.secondary_fixed_dim.default.hex}}):\
*.mp4=(_fzf_hex_to_ansi {{colors.secondary_fixed_dim.default.hex}})"

set -gx FZF_DEFAULT_OPTS "\
--color=bg:-1 \
--color=fg:{{colors.on_surface.default.hex}} \
--color=hl:{{colors.primary.default.hex}} \
--color=bg+:-1 \
--color=fg+:{{colors.on_surface.default.hex}} \
--color=hl+:{{colors.primary.default.hex}} \
--color=info:{{colors.on_surface_variant.default.hex}} \
--color=prompt:{{colors.primary.default.hex}} \
--color=pointer:{{colors.primary.default.hex}} \
--color=marker:{{colors.tertiary.default.hex}} \
--color=spinner:{{colors.tertiary.default.hex}} \
--color=header:{{colors.secondary.default.hex}} \
--color=gutter:-1 \
--color=border:{{colors.outline_variant.default.hex}}"