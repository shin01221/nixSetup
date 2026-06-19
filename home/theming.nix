{
  config,
  pkgs,
  lib,
  ...
}:

{
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  xdg.configFile."gtk-4.0/settings.ini".force = true;

  home.packages = with pkgs; [
    darkly
    colloid-icon-theme
  ];
}
