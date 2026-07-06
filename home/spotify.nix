{ pkgs, config, lib, ... }:

let
  spicetifyExtensions = {
    "shuffle+.js" = pkgs.fetchurl {
      name = "shuffle+.js";
      url = "https://raw.githubusercontent.com/spicetify/cli/main/Extensions/shuffle%2B.js";
      hash = "sha256-mg6RSPTfOHRjunTvm1ZGZOXPakhxvy0jNPJIPQHbBek=";
    };
    "copytoclipboard.js" = pkgs.fetchurl {
      name = "copytoclipboard.js";
      url = "https://raw.githubusercontent.com/pnthach95/spicetify-extensions/main/dist/copytoclipboard.js";
      hash = "sha256-s2WwIo53n6UlvUwNbpeUIVrsdOxl0o3Pxif2/O5Etsk=";
    };
    "hidePodcasts.js" = pkgs.fetchurl {
      name = "hidePodcasts.js";
      url = "https://raw.githubusercontent.com/theRealPadster/spicetify-hide-podcasts/main/hidePodcasts.js";
      hash = "sha256-cn5aL5E39L536sg9I0oM6FjF1hjn/1YRam3vAXk/w/g=";
    };
    "adblock.js" = pkgs.fetchurl {
      name = "adblock.js";
      url = "https://raw.githubusercontent.com/CharlieS1103/spicetify-extensions/main/adblock/adblock.js";
      hash = "sha256-Uj8afW1sAKUKkUwF88JQrD2U+PJf8q3bG+7IF0e8tpk=";
    };
    "volumePercentage.js" = pkgs.fetchurl {
      name = "volumePercentage.js";
      url = "https://raw.githubusercontent.com/jeroentvb/spicetify-volume-percentage/main/volumePercentage.js";
      hash = "sha256-G3+110V1uo/Vt7g2j45AD9ul7k3VKpnn16xOR6hYGnU=";
    };
  };
in
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
    SPICE="${pkgs.spicetify-cli}/bin/spicetify"
    SPOTIFY_STORE="${pkgs.spotify}/share/spotify"
    SPOTIFY_MUTABLE="$HOME/.local/share/spicetify/Spotify"
    EXTENSIONS_DIR="$HOME/.config/spicetify/Extensions"
    SPICE_CONFIG="$HOME/.config/spicetify/config-xpui.ini"

    # Symlink extension files from nix store (only if missing)
    mkdir -p "$EXTENSIONS_DIR"
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: ''
      if [ ! -f "$EXTENSIONS_DIR/${name}" ]; then
        ln -sf "${path}" "$EXTENSIONS_DIR/${name}"
      fi
    '') spicetifyExtensions)}

    # Check if the mutable copy is stale or missing
    if [ ! -f "$SPOTIFY_MUTABLE/spotify" ] || [ "$SPOTIFY_STORE/spotify" -nt "$SPOTIFY_MUTABLE/spotify" ] 2>/dev/null; then
      rm -rf "$SPOTIFY_MUTABLE"
      cp -r "$SPOTIFY_STORE" "$SPOTIFY_MUTABLE"
      chmod -R u+w "$SPOTIFY_MUTABLE"
      $SPICE config spotify_path "$SPOTIFY_MUTABLE"
      $SPICE config current_theme Comfy
      $SPICE config color_scheme Comfy
      $SPICE restore backup 2>/dev/null || true
      $SPICE backup apply
    fi

    # Configure extensions and apply (only if not already set)
    CHANGED=0
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: _: ''
      if ! grep -q "${name}" "$SPICE_CONFIG" 2>/dev/null; then
        $SPICE config extensions "${name}"
        CHANGED=1
      fi
    '') spicetifyExtensions)}
    if [ "$CHANGED" = 1 ]; then
      $SPICE apply
    fi

    # Fix wrapper to launch mutable .spotify-wrapped instead of nix store one
    if [ -f "$SPOTIFY_MUTABLE/spotify" ]; then
      sed -i "s|/nix/store/[^/]*/share/spotify/\.spotify-wrapped|$SPOTIFY_MUTABLE/.spotify-wrapped|g" "$SPOTIFY_MUTABLE/spotify"
      # Fix shebang — use env to avoid stale nix store paths after GC
      sed -i '1s|#!/nix/store/[^/]*/bin/bash.*|#!/usr/bin/env bash|' "$SPOTIFY_MUTABLE/spotify"
    fi

    # Symlink the mutable spotify into ~/.local/bin so it's found first in PATH
    mkdir -p "$HOME/.local/bin"
    ln -sf "$SPOTIFY_MUTABLE/spotify" "$HOME/.local/bin/spotify"
  '';
}
