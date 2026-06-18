{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.security;
in
{
  options.workstation.security.enable = lib.mkEnableOption "Security hardening (AppArmor, sudo hardening)";

  config = lib.mkIf cfg.enable {
    security = {
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
        packages = [ pkgs.apparmor-profiles ];
      };
      sudo.extraConfig = "Defaults pwfeedback";
    };
  };
}
