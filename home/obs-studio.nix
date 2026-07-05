{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    
    # Optional: Enable Nvidia hardware acceleration
    # package = (pkgs.obs-studio.override { cudaSupport = true; });

    # Add required OBS plugins directly from the nixpkgs repository
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };
}

