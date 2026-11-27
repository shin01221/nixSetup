{ inputs, config, ... }:
let
  mkHost = import ../../../modules/flake/_mk-host.nix { inherit inputs; };
  mkHome = import ../../../modules/flake/_mk-home.nix { inherit inputs; };

  nixosFeatures = [
    "server-baseline"
    "nixvim"
  ];

  homeFeatures = [
    "tmux"
    "fish"
  ];

  hostFeatures = nixosFeatures ++ homeFeatures;
in
{
  flake.nixosConfigurations.node1 = mkHost {
    hostName = "node1";
    userName = "node1";
    nixosModules = config.flake.modules.nixos;
    inherit nixosFeatures hostFeatures;
    extraModules = [
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      ./host.nix
    ];
  };

  flake.homeConfigurations.node1 = mkHome {
    hostName = "node1";
    userName = "node1";
    homeModules = config.flake.modules.homeManager;
    inherit homeFeatures hostFeatures;
  };
}
