{ lib, ... }: {
  # ── Home-manager toggleable option tree ──────────────────────
  options.workstation.home = {
    fish = lib.mkEnableOption "Fish shell config";
    scripts = lib.mkEnableOption "Custom scripts";
    theming = lib.mkEnableOption "GTK/QT theming";
    tmux = {
      enable = lib.mkEnableOption "Tmux config";
      sessionx = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable tmux-sessionx plugin";
        };
      };
    };
    spotify = lib.mkEnableOption "Spotify/spicetify";
    xdg = lib.mkEnableOption "XDG MIME and user-dirs";
    obs-studio = lib.mkEnableOption "OBS Studio config";
    foot = lib.mkEnableOption "Foot terminal config";
    ghostty = lib.mkEnableOption "Ghostty terminal config";
    dolphin = lib.mkEnableOption "Dolphin file manager";
    bash = lib.mkEnableOption "Bash config";
    zsh = lib.mkEnableOption "Zsh config";

    # Coupled to system options — defaults set below via mkDefault
    niri = lib.mkEnableOption "Niri WM config";
    noctalia = lib.mkEnableOption "Noctalia shell config";
    wlr-which-key = lib.mkEnableOption "WLR which key config";
    audio = lib.mkEnableOption "MPD/audio config";
    steam = lib.mkEnableOption "Steam Big Picture HM";
    kde = lib.mkEnableOption "KDE Plasma HM";
    hypr = lib.mkEnableOption "Hyprland HM";
    xfce = lib.mkEnableOption "XFCE HM";
    gnome = lib.mkEnableOption "GNOME HM";
  };
}
