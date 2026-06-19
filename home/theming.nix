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
    platformTheme.name = "kde";
  };

  home.packages = with pkgs; [
    kdePackages.breeze              # Breeze Qt widget style
  ];

  xdg.configFile = {
  };
}
