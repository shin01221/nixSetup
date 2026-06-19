{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.baseline.packages;
  future-cursors = pkgs.callPackage ../pkgs/future-cursor.nix { };
  toolsPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    yubikey-manager
    wget
    sesh
    git
    killall
    bat
    chafa
    curl
    ffmpegthumbnailer
    fzf
    tmux
    direnv
    atuin
    trash-cli
    zoxide
    btop
    ripgrep
    fd
    grim
    htop
    curl
    tree
    eza
    ghostty
    foot
    fastfetch
    starship
    lazyssh
    nixfmt
    blueman
    ffmpeg
    whois
    parted
    usbutils
    smartmontools
    pciutils
    file
    dig
    imagemagick
    jq
    brightnessctl
    acpilight
    libnotify
    glib
    poppler
    satty
    sd
    slurp
    future-cursors
    screen
    speedtest
    unzip
    parallel
  ];

  devPackages = with pkgs; [
    rustup
    cargo
    gcc
    rustlings
    terraform
    distrobox
  ];

  themePackages = with pkgs; [
    matugen
    nwg-look
  ];

  appsPackages = with pkgs; [
    yubioath-flutter
    evtest
    kdePackages.dolphin.out
    thunar
    vlc
    wlr-which-key
    libreoffice
    gnome-calculator
    kdePackages.okular
    kdePackages.gwenview
    opencode
    wayscriber
    mpv
    calibre
    obs-studio
    obs-do
    qbittorrent
  ];
in
{
  options.workstation.baseline.packages = {
    tools = lib.mkEnableOption "CLI tools and utilities";
    dev = lib.mkEnableOption "Development tools";
    themes = lib.mkEnableOption "Theme-related packages";
    apps = lib.mkEnableOption "Desktop applications";
  };

  config = {
    environment.systemPackages =
      (lib.optionals cfg.tools toolsPackages)
      ++ (lib.optionals cfg.dev devPackages)
      ++ (lib.optionals cfg.themes themePackages)
      ++ (lib.optionals cfg.apps appsPackages);
  };
}
