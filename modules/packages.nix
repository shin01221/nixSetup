{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.baseline.packages;
  # future-cursors = pkgs.callPackage ../pkgs/future-cursor.nix { };
  toolsPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    # yubikey-manager
    wget
    sesh
    git
    killall
    lazygit
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
    screen
    gh
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
    telegram-desktop
    yubioath-flutter
    vesktop
    evtest
    kdePackages.dolphin.out
    kdePackages.qtsvg
    thunar
    vlc
    upscayl
    wlr-which-key
    libreoffice
    gnome-calculator
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.ark
    opencode
    wayscriber
    mpv
    calibre
    obs-studio
    qbittorrent
    kdePackages.kio-extras
    libmtp
    neovide
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

    services.udev.packages = [ pkgs.libmtp ];
  };
}
