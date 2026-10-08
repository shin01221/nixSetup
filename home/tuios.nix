{
  # Symlink tuios config into place entry by entry.
  # themes/ is intentionally unmanaged: noctalia renders noctalia.json
  # (plus timestamped variants) there at runtime, which cannot target a
  # read-only nix store path.
  xdg.configFile = {
    "tuios/config.toml".source = ../config/tuios/config.toml;
    "tuios/dock".source = ../config/tuios/dock;
    "tuios/layouts".source = ../config/tuios/layouts;
  };
}
