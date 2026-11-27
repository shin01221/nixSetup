{ inputs, config, ... }:
let
  mkHost = import ../../../modules/flake/_mk-host.nix { inherit inputs; };
  mkHome = import ../../../modules/flake/_mk-home.nix { inherit inputs; };

  nixosFeatures = [
    "baseline"
    "tools"
    "dev"
    "apps"
    "luciole"
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
    "touchpad"
    "sound"
    "tlp"
  ];

  homeFeatures = [
    "umbriel"
    "games"
    "media"
    "audio"
    "zen"
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

  hostFeatures = nixosFeatures ++ homeFeatures;
in
{
  flake.nixosConfigurations.shin = mkHost {
    hostName = "nixos";
    userName = "shin";
    withUnstable = true;
    nixosModules = config.flake.modules.nixos;
    inherit nixosFeatures hostFeatures;
    extraModules = [
      ./hardware-configuration.nix
      ./host.nix
    ];
  };

  flake.homeConfigurations.shin = mkHome {
    hostName = "nixos";
    userName = "shin";
    withUnstable = true;
    homeModules = config.flake.modules.homeManager;
    inherit homeFeatures hostFeatures;
  };
}
