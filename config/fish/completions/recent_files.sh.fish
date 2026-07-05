# recent_files.sh completions for fish shell

# Flags
complete -c recent_files.sh -l save      -d "Copy selected paths to clipboard (wl-copy)"
complete -c recent_files.sh -l print     -d "Print selected paths to stdout"
complete -c recent_files.sh -l no-picker -d "Skip fzf, print N most recent files directly"
complete -c recent_files.sh -l help      -d "Show this help and exit"

# Directory completion for DIR argument
complete -c recent_files.sh -k -a "(__fish_complete_directories)" -d "Directory"
