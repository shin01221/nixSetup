{ ... }:
{
  flake.modules.nixos.umbriel =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      userName =
        if config.workstation ? baseline && config.workstation.baseline ? userName then
          config.workstation.baseline.userName
        else
          "shin";

      umbriel = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
      umbrielPortal =
        inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-umbriel;
    in
    {
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

      security.polkit.enable = true;

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "net.reactivated.fprint.device.enroll" &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';

      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        papirus-icon-theme
        gpu-screen-recorder
        wl-clipboard
        libsForQt5.qt5ct
        qt6Packages.qt6ct
        mpvpaper
        polkit_gnome
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
