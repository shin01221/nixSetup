{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.services;
in
{
  options.workstation.services.enable = lib.mkEnableOption "Additional system services (SSD trim, keyring)";

  config = lib.mkIf cfg.enable {
    services = {
      fstrim.enable = true;
      devmon.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      blueman.enable = true;
      tumbler.enable = true;
      gnome.gnome-keyring.enable = true;
    };
  };
}
