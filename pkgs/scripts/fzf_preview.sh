#!/usr/bin/env bash

has_cmd() { command -v "$1" >/dev/null 2>&1; }

in_tmux() { [ -n "$TMUX" ]; }

is_kitty_protocol() {
    [ -n "$KITTY_WINDOW_ID" ] && return 0
    [ "$TERM_PROGRAM" = "ghostty" ] && return 0
    [ "$TERM_PROGRAM" = "kitty" ] && return 0
    [ -n "$GHOSTTY_RESOURCES_DIR" ] && return 0
    case "$TERM" in
        xterm-kitty|xterm-ghostty|*-ghostty) return 0 ;;
    esac
    return 1
}

has_sixel() {
    case "$TERM_PROGRAM" in
        foot) return 0 ;;
    esac
    case "$TERM" in
        foot|foot-*|*-sixel) return 0 ;;
    esac
    return 1
}

display_image_kitty() {
    local img="$1"
    [ ! -f "$img" ] && return 1
    chafa -f kitty --scale=max \
        --size="${FZF_PREVIEW_COLUMNS:-80}x${FZF_PREVIEW_LINES:-40}" "$img" 2>/dev/null
}

display_image_sixel() {
    local img="$1"
    [ ! -f "$img" ] && return 1
    chafa -f sixels --scale=max \
        --size="${FZF_PREVIEW_COLUMNS:-80}x${FZF_PREVIEW_LINES:-40}" "$img" 2>/dev/null
}

display_image_chafa() {
    local img="$1"
    [ ! -f "$img" ] && return 1
    chafa -f symbols --symbols=all --scale=max --work=9 \
        --size="${FZF_PREVIEW_COLUMNS:-80}x${FZF_PREVIEW_LINES:-40}" "$img" 2>/dev/null
}

convert_image() {
    local img="$1"
    case "$(file -b --mime-type "$img" 2>/dev/null)" in
        image/webp)
            local converted
            converted=$(mktemp /tmp/fzf_preview_conv.XXXXXX.png)
            if has_cmd dwebp; then
                dwebp "$img" -o "$converted" 2>/dev/null && echo "$converted" && return 0
            fi
            if has_cmd convert; then
                convert "$img" "$converted" 2>/dev/null && echo "$converted" && return 0
            fi
            if has_cmd ffmpeg; then
                ffmpeg -i "$img" "$converted" 2>/dev/null && echo "$converted" && return 0
            fi
            rm -f "$converted" 2>/dev/null
            return 1
            ;;
    esac
    echo "$img"
}

image_allowed_in_tmux() {
    in_tmux || return 0
    [ "$(tmux show -g allow-passthrough 2>/dev/null)" = "on" ]
}

display_image() {
    local img="$1"
    local converted
    converted=$(convert_image "$img") || { echo "Cannot display: $(basename "$img")"; return; }

    if image_allowed_in_tmux && has_cmd chafa; then
        if has_sixel; then
            display_image_sixel "$converted" || display_image_kitty "$converted" || display_image_chafa "$converted"
        elif is_kitty_protocol; then
            display_image_kitty "$converted" || display_image_chafa "$converted"
        else
            display_image_chafa "$converted"
        fi
    elif has_cmd chafa; then
        display_image_chafa "$converted"
    else
        echo "Image: $(basename "$img")"
    fi

    [ "$converted" != "$img" ] && rm -f "$converted" 2>/dev/null
}

[ "${BASH_SOURCE[0]}" = "$0" ] || return 0

file="$1"
[ -z "$file" ] && { echo "Usage: fzf_preview.sh <file>" >&2; exit 1; }

mime_type=$(file -b --mime-type "$file" 2>/dev/null)

case "$mime_type" in
    image/*)
        display_image "$file"
        ;;
    video/*)
        if has_cmd ffmpegthumbnailer; then
            tmp_thumb=$(mktemp /tmp/fzf_preview_thumb.XXXXXX.jpg)
            if ffmpegthumbnailer -i "$file" -o "$tmp_thumb" -s 480 -q 10 2>/dev/null; then
                display_image "$tmp_thumb"
            else
                echo "Video: $(basename "$file")"
            fi
            rm -f "$tmp_thumb" 2>/dev/null
        else
            echo "Video: $(basename "$file")"
        fi
        ;;
    text/*|application/json|application/javascript|application/xml|application/x-shellscript)
        if has_cmd bat; then
            bat --style=numbers --color=always --line-range :100 "$file" 2>/dev/null || head -100 "$file"
        else
            head -100 "$file"
        fi
        ;;
    inode/directory)
        ls --color=always "$file" 2>/dev/null || echo "Directory: $file"
        ;;
    application/pdf)
        if has_cmd pdftotext; then
            pdftotext "$file" - 2>/dev/null | head -100
        else
            echo "PDF: $(basename "$file")"
        fi
        ;;
    *)
        echo "File: $(basename "$file")"
        echo "Type: $mime_type"
        ;;
esac
