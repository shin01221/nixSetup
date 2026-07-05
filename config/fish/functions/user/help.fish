function help
    # Check if a command name was passed
    if test (count $argv) -eq 0
        echo "Usage: helpv <command> [arguments...]"
        return 1
    end

    # 1. Use command substitution to execute the command and capture its output.
    #    The '^' character redirects stderr (2) to stdout (1) in Fish substitution.
    # 2. Pipe the captured output to nvim.
    # 3. This avoids the ambiguous parsing of the &> | sequence.

    $argv --help ^/dev/stdout | nvim -R -c "set filetype=man" -
end
