function yazi
    set -l wrapper (readlink -f (command -v yazi))
    set -l real_yazi (grep '^exec "' $wrapper | sed 's/^exec "//;s/" .*//')
    if test -n "$real_yazi" -a -x "$real_yazi"
        env YAZI_CONFIG_HOME="$HOME/.config/yazi" "$real_yazi" $argv
    else
        command yazi $argv
    end
end
