{ pkgs, config, lib, ... }:

{
  home.packages = with pkgs; [
    spotify
    spicetify-cli
  ];

  xdg.desktopEntries."spotify" = {
    name = "Spotify";
    exec = "spotify %U";
    terminal = false;
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    mimeType = [ "x-scheme-handler/spotify" ];
  };

  home.activation.setup-spicetify = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    SPOTIFY_STORE="${pkgs.spotify}/share/spotify"
    SPOTIFY_MUTABLE="$HOME/.local/share/spicetify/Spotify"

    # Check if the mutable copy is stale or missing
    if [ ! -f "$SPOTIFY_MUTABLE/spotify" ] || [ "$SPOTIFY_STORE/spotify" -nt "$SPOTIFY_MUTABLE/spotify" ] 2>/dev/null; then
      rm -rf "$SPOTIFY_MUTABLE"
      cp -r "$SPOTIFY_STORE" "$SPOTIFY_MUTABLE"
      chmod -R u+w "$SPOTIFY_MUTABLE"
      $VERBOSE_EXEC spicetify config spotify_path "$SPOTIFY_MUTABLE"
      $VERBOSE_EXEC spicetify config current_theme Comfy
      $VERBOSE_EXEC spicetify config color_scheme Comfy
      $VERBOSE_EXEC spicetify config extensions shuffle
      $VERBOSE_EXEC spicetify config extensions copyToClipboard
      $VERBOSE_EXEC spicetify config extensions hidePodcasts
      $VERBOSE_EXEC spicetify config extensions adblock
      $VERBOSE_EXEC spicetify config extensions volumePercentage
      $VERBOSE_EXEC spicetify backup apply
    fi

    # Fix wrapper to launch mutable .spotify-wrapped instead of nix store one
    if [ -f "$SPOTIFY_MUTABLE/spotify" ]; then
      sed -i "s|/nix/store/[^/]*/share/spotify/\.spotify-wrapped|$SPOTIFY_MUTABLE/.spotify-wrapped|g" "$SPOTIFY_MUTABLE/spotify"
    fi

    # Symlink the mutable spotify into ~/.local/bin so it's found first in PATH
    mkdir -p "$HOME/.local/bin"
    ln -sf "$SPOTIFY_MUTABLE/spotify" "$HOME/.local/bin/spotify"
  '';
}
