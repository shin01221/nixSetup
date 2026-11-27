{ ... }:
{
  flake.modules.nixos.apps =
    { pkgs, inputs, ... }:
    {
      environment.systemPackages = with pkgs; [
        telegram-desktop
        vesktop
        evtest
        kdePackages.dolphin.out
        kdePackages.qtsvg
        thunar
        vlc
        upscayl
        inputs.wlr-which-key-patched.packages.${pkgs.stdenv.hostPlatform.system}.default
        libreoffice
        gnome-calculator
        kdePackages.okular
        kdePackages.gwenview
        kdePackages.ark
        p7zip
        _7zz
        unrar
        (pkgs.unstable or pkgs).opencode
        wayscriber
        gparted
        calibre
        qbittorrent
        kdePackages.kio-extras
        libmtp
        neovide
        tesseract
        wl-screenrec
        handbrake
      ];

      services.udev.packages = [ pkgs.libmtp ];
    };
}
