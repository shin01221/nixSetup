{ inputs }:
{
  hostName,
  userName,
  nixosFeatures,
  hostFeatures ? nixosFeatures,
  nixosModules,
  withUnstable ? false,
  extraModules ? [ ],
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
    lib.concatMap (name: lib.optional (ns ? ${name}) ns.${name}) nixosFeatures;

  isServer = builtins.elem "server-baseline" hostFeatures;
in
inputs.nixpkgs-stable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs userName homeDir hostName;
    self = inputs.self;
    inherit hostFeatures isServer;
  };
  modules = [
    inputs.agenix.nixosModules.default
    {
      networking.hostName = hostName;
      nixpkgs.overlays = lib.optional withUnstable (final: prev: {
        unstable = pkgsUnstable;
      });
    }
  ]
  ++ halves nixosModules
  ++ extraModules;
}
