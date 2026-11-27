{ ... }:
{
  flake.modules.nixos.kde =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      services.displayManager.sddm = {
        enable = true;
        theme = "breeze";
        wayland.enable = true;
      };
      services.desktopManager.plasma6.enable = true;
      services.displayManager.defaultSession = "plasma";
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        konsole
        elisa
        discover
        ark
        kcalc
        gwenview
        khelpcenter
        kate
        ktexteditor
        print-manager
        okular
      ];
      qt = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        tokyonight-gtk-theme
        rose-pine-cursor
      ];
    };
}
