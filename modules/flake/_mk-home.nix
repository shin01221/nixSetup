{ inputs }:
{
  userName,
  hostName,
  homeFeatures,
  hostFeatures ? homeFeatures,
  homeModules,
  withUnstable ? false,
  extraModules ? [ ],
}:
let
  lib = inputs.nixpkgs-stable.lib;
  system = "x86_64-linux";
  homeDir = "/home/${userName}";

  pkgsUnstable =
    if withUnstable then
      import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
          permittedInsecurePackages = [ "electron-39.8.10" ];
        };
      }
    else
      null;

  pkgs = import inputs.nixpkgs-stable {
    inherit system;
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
      permittedInsecurePackages = [ "electron-39.8.10" ];
    };
    overlays = lib.optional withUnstable (final: prev: {
      unstable = pkgsUnstable;
    });
  };

  halves = ns:
    lib.concatMap (name: lib.optional (ns ? ${name}) ns.${name}) homeFeatures;

  isServer = builtins.elem "server-baseline" hostFeatures;
in
inputs.home-managerS.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit inputs userName homeDir hostName isServer hostFeatures;
    self = inputs.self;
  };

  modules =
    lib.optional (homeModules ? common) homeModules.common
    ++ halves homeModules
    ++ extraModules;
}
