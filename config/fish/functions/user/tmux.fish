function tmux-set
    # Skip tmux-set if NO_TMUX is set
    if set -q NO_TMUX
        return
    end

    # Skip if already inside tmux
    if set -q TMUX
        return
    end

    # Skip if inside TTY
    if test "$XDG_SESSION_TYPE" = tty
        return
    end

    if test -f ~/.local/state/tmux_last_session
        set last_choice (string collect < ~/.local/state/tmux_last_session)
    end
    set sessions (tmux ls -F '#S' 2>/dev/null)
    if not set -q TMUX
        # remember file
        switch (count $sessions)
            case 0
                tmux new -As main
            case '*'
                tmux attach -t "$last_choice"; or tmux new -s "$last_choice"
        end
    end
end
