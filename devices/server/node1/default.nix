{ inputs, config, ... }:
let
  mkHost = import ../../../modules/flake/_mk-host.nix { inherit inputs; };
in
{
  flake.nixosConfigurations.node1 = mkHost {
    hostName = "node1";
    userName = "node1";
    nixosModules = config.flake.modules.nixos;
    homeModules = config.flake.modules.homeManager;
    features = [
      "server-baseline"
      "nixvim"
      "tmux"
      "fish"
    ];
    extraModules = [
      ./hardware-configuration.nix
      inputs.disko.nixosModules.disko
      ./host.nix
    ];
  };
}
