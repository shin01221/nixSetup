function down
    set quality $argv[1] # First argument
    set args $argv[2..-1] # All remaining arguments
    yt-dlp -S "res:$quality" -- $args
end
