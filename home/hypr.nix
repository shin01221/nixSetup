{ ... }:
{
  flake.modules.homeManager.hypr =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    {

      xdg.configFile."hypr" = {
        source = ../config/hypr;
        recursive = true;
      };

      xdg.configFile."waybar" = {
        source = ../config/waybar;
        recursive = true;
      };

      xdg.dataFile."icons/future-cyan" = {
        source = ../config/icons/future-cyan;
        recursive = true;
      };

      gtk = {
        enable = true;

        theme = {
          name = "Tokyonight-Dark";
          package = pkgs.tokyonight-gtk-theme;
        };

        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };

        gtk3.extraConfig = {
          "gtk-application-prefer-dark-theme" = 1;
        };

        gtk4.extraConfig = {
          "gtk-application-prefer-dark-theme" = 1;
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Tokyonight-Dark";
          icon-theme = "Papirus";
        };
      };

    }
  ;
}
