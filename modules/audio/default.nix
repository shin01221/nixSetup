{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mpd
    cava
    mpd-mpris
    mpc
    playerctl
    rmpc

  ];
}
