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

      # Home Manager 26.05 has no home.backupFileExtension option. Standalone
      # Home Manager reads this environment variable during activation.
      environment.variables.HOME_MANAGER_BACKUP_EXT = lib.mkDefault "backup";

      nixpkgs.overlays = lib.optional withUnstable (final: prev: {
        unstable = pkgsUnstable;
      });
    }
  ]
  ++ halves nixosModules
  ++ extraModules;
}
