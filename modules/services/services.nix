{ ... }:
{
  flake.modules.nixos.services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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
