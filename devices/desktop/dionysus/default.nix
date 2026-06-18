{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "dionysus";

  services.seatd = {
    enable = true;
    user = "gumbo";
    group = "video";
  };

  services.getty = {
    autologinUser = "gumbo";
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    gamescope
  ];
}
