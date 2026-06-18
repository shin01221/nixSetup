{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.workstation.system;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  options.workstation.system.enable = lib.mkEnableOption "System utilities (nix-index-database, GPG agent)";

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index-database.comma.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
