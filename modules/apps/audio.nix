{ ... }:
{
  flake.modules.nixos.audio =
    {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        # mpd, mpd-mpris, mpc, playerctl, rmpc now via home/audio.nix (home.packages) - deduplicated
        cava
        lrcget
        easyeffects
        inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    }
  ;
}
