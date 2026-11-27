{ ... }:
{
  flake.modules.homeManager.umbriel =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:

    {
      imports = [ inputs.umbriel.homeModules.default ];

      programs.umbriel.enable = true;

      home.pointerCursor = lib.mkDefault {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      home.sessionVariables = lib.mkDefault {
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
      };

      xdg.configFile."umbriel/config.toml" = {
        source = ../config/umbriel/config.toml;
        force = true;
      };

      xdg.configFile."umbriel/solid.toml" = {
        source = ../config/umbriel/solid.toml;
        force = true;
      };

      xdg.configFile."umbriel/transparency.toml" = {
        source = ../config/umbriel/transparency.toml;
        force = true;
      };

      # Writable, unmanaged override layer for the transparency toggle. The main
      # config includes it with an absolute ~ path so it keeps working when
      # config.toml is a read-only Home Manager symlink.
      home.activation.ensureUmbrielOverrideToml = lib.hm.dag.entryAfter [ "writeBoundary" ] (
        let
          initialOverride = pkgs.writeText "umbriel-override-toml" ''
            # Writable Umbriel overrides. Not managed by Home Manager.
            # transparency-toggle.sh toggles the two include entries below.
            # Blur settings live here so they can be changed live.

            [include.optional]
            files = [
              # "~/.config/umbriel/solid.toml",
              # "~/.config/umbriel/transparency.toml",
            ]

            [appearance.blur]
            enabled = true
            optimized = true
            passes = 4
            radius = 5
            noise = 0.06
            saturation = 1.8

            [[window_rule]]
            blur = true
          '';
        in
        ''
          if [ ! -f "$HOME/.config/umbriel/override.toml" ]; then
            install -Dm644 ${initialOverride} "$HOME/.config/umbriel/override.toml"
          fi
        ''
      );
    }
  ;
}
