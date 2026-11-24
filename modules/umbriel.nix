{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.umbriel;
  userName =
    if config.workstation ? baseline && config.workstation.baseline ? userName then
      config.workstation.baseline.userName
    else
      "shin";

  umbriel = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
  umbrielPortal = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-umbriel;
in
{
  options.workstation.umbriel.enable = lib.mkEnableOption "Umbriel compositor workstation environment with Noctalia Shell";

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = lib.mkDefault true;

    # The compositor is installed through Home Manager. These register the
    # display-manager session, user units, and portal integration.
    services.displayManager.sessionPackages = [ umbriel ];
    systemd.packages = [ umbriel ];

    xdg.portal = {
      enable = lib.mkDefault true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        umbrielPortal
      ];
      config = {
        common.default = "gtk";
        umbriel.default = [
          "umbriel"
          "gtk"
        ];
      };
    };

    qt = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      papirus-icon-theme
      gpu-screen-recorder
      wl-clipboard
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      mpvpaper
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --sessions /run/current-system/sw/share/wayland-sessions --cmd ${umbriel}/bin/start-umbriel";
          user = "greeter";
        };

        initial_session = {
          command = "${umbriel}/bin/start-umbriel";
          user = userName;
        };
      };
    };
  };
}
