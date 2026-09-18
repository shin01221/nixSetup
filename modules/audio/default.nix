{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.workstation.audio;
in
{
  options.workstation.audio.enable = lib.mkEnableOption "Audio packages (MPD, cava, playerctl)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # mpd, mpd-mpris, mpc, playerctl, rmpc now via home/audio.nix (home.packages) - deduplicated
      cava
      lrcget
      easyeffects
      unstable.kopuz
    ];
  };
}
