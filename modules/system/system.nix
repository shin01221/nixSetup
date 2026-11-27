{ ... }:
{
  flake.modules.nixos.system =
    {
      config,
      lib,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index
      ];

      programs = {
        nix-index-database.comma.enable = true;
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };
    };
}
