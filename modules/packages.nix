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
    hyprpicker
    unstable.miru
    nh
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
    # tmux now via home/tmux.nix (programs.nix-tmux) - deduplicated
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
    # ghostty now via home/ghostty.nix - deduplicated
    # foot now via home/foot.nix programs.foot - deduplicated
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
    unzip
    parallel
    man-pages
    swappy
    psmisc
    inputs.wayscrollshot.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  devPackages = with pkgs; [
    # rustup
    # cargo
    # gcc
    # rustlings
    # terraform
    # distrobox
    python3
    devenv
    ansible
    minikube
    kubectl
  ];

  themePackages = with pkgs; [
    matugen
    nwg-look
  ];

  appsPackages = with pkgs; [
    telegram-desktop
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
    p7zip
    _7zz
    unrar
    unstable.opencode
    wayscriber
    gparted
    # mpv now via modules/media home-manager.sharedModules programs.mpv - deduplicated
    calibre
    # obs-studio now via home/obs-studio.nix programs.obs-studio - deduplicated
    qbittorrent
    kdePackages.kio-extras
    libmtp
    neovide
    tesseract
    wl-screenrec
    handbrake
  ];
in
{
  options.workstation.baseline.packages = {
    tools = lib.mkEnableOption "CLI tools and utilities";
    dev = lib.mkEnableOption "Development tools";
    themes = lib.mkEnableOption "Theme-related packages";
    apps = lib.mkEnableOption "Desktop applications";
  };

  config = lib.mkIf (cfg.tools || cfg.dev || cfg.themes || cfg.apps) {
    environment.systemPackages =
      lib.optionals cfg.tools toolsPackages
      ++ lib.optionals cfg.dev devPackages
      ++ lib.optionals cfg.themes themePackages
      ++ lib.optionals cfg.apps appsPackages;

    services.udev.packages = lib.optionals cfg.apps [ pkgs.libmtp ];
  };
}
