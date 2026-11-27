{ inputs, config, ... }:
let
  mkHost = import ../../../modules/flake/_mk-host.nix { inherit inputs; };
in
{
  flake.nixosConfigurations.shin = mkHost {
    hostName = "nixos";
    userName = "shin";
    withUnstable = true;
    nixosModules = config.flake.modules.nixos;
    homeModules = config.flake.modules.homeManager;
    features = [
      "baseline"
      "tools"
      "dev"
      "apps"
      "nixvim"
      "umbriel"
      "yazi"
      "virtualization"
      "nvidia"
      "games"
      "network"
      "security"
      "services"
      "system"
      "memory"
      "media"
      "audio"
      "touchpad"
      "sound"
      "zen"
      "tlp"
      "fish"
      "scripts"
      "theming"
      "tmux"
      "tuios"
      "spotify"
      "xdg"
      "obs-studio"
      "obsidian"
      "zapfast"
      "foot"
      "ghostty"
      "dolphin"
      "luciole"
      "matugen"
      "noctalia"
      "wlr-which-key"
    ];
    extraModules = [
      ./hardware-configuration.nix
      ./host.nix
    ];
  };
}
