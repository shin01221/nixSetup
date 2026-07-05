function venv
    if test -z "$argv[1]"
        echo "Usage: venv /path/to/venv"
        return 1
    end

    set venv_path (realpath $argv[1])

    if not test -f "$venv_path/bin/activate.fish"
        echo "Invalid venv: $venv_path"
        return 1
    end

    if functions -q deactivate
        deactivate
    end

    source "$venv_path/bin/activate.fish"

    echo $venv_path >~/.config/fish/venv_state
end
