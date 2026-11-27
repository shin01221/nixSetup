{ inputs }:
{
  hostName,
  userName,
  features,
  nixosModules,
  homeModules,
  withUnstable ? false,
  extraModules ? [ ],
  extraHomeModules ? [ ],
}:
let
  lib = inputs.nixpkgs-stable.lib;
  homeDir = "/home/${userName}";

  pkgsUnstable =
    if withUnstable then
      import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
          permittedInsecurePackages = [ "electron-39.8.10" ];
        };
      }
    else
      null;

  halves = ns:
    lib.concatMap (name: lib.optional (ns ? ${name}) ns.${name}) features;

  isServer = builtins.elem "server-baseline" features;
in
inputs.nixpkgs-stable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs userName homeDir hostName;
    self = inputs.self;
    hostFeatures = features;
    inherit isServer;
  };
  modules = [
    inputs.home-managerS.nixosModules.home-manager
    inputs.agenix.nixosModules.default
    {
      networking.hostName = hostName;
      nixpkgs.overlays = lib.optional withUnstable (final: prev: {
        unstable = pkgsUnstable;
      });
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit inputs userName homeDir hostName;
          self = inputs.self;
          hostFeatures = features;
          inherit isServer;
        };
        users.${userName}.imports =
          lib.optional (homeModules ? common) homeModules.common
          ++ halves homeModules
          ++ extraHomeModules;
      };
    }
  ]
  ++ halves nixosModules
  ++ extraModules;
}
