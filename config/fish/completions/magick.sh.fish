# magick.sh completions

# Flags
complete -c magick.sh -l help -d "Show help"
complete -c magick.sh -l replace -d "Edit files in-place"
complete -c magick.sh -l batch -d "Batch process all images in a directory"

# Modes
complete -c magick.sh -l resize-height -d "Crop from top/bottom by HEIGHT"
complete -c magick.sh -l resize-width -d "Crop from left/right/center by WIDTH"
complete -c magick.sh -l downscale -d "Downscale by PERCENT"
complete -c magick.sh -l sort -d "Sort images into subdirectories"

# After --sort: directory
complete -c magick.sh -n "__fish_seen_subcommand_from --sort" -a "(__fish_complete_directories '')" -d "Directory"

# Position arguments for --resize-height
complete -c magick.sh -n "__fish_seen_subcommand_from --resize-height; and not __fish_seen_subcommand_from --batch --replace" -k -a "
top\t'Crop from top (keep bottom)'
bottom\t'Crop from bottom (keep top)'
"

# Position arguments for --resize-width
complete -c magick.sh -n "__fish_seen_subcommand_from --resize-width; and not __fish_seen_subcommand_from --batch --replace" -k -a "
left\t'Crop from left (keep right)'
right\t'Crop from right (keep left)'
center\t'Crop from center'
"

# Position optional with --replace or --batch
complete -c magick.sh -n "__fish_seen_subcommand_from --resize-height; and __fish_seen_subcommand_from --replace --batch" -k -a "
top\t'Crop from top (keep bottom)'
bottom\t'Crop from bottom (keep top)'
"

complete -c magick.sh -n "__fish_seen_subcommand_from --resize-width; and __fish_seen_subcommand_from --replace --batch" -k -a "
left\t'Crop from left (keep right)'
right\t'Crop from right (keep left)'
center\t'Crop from center'
"
