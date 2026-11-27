{ ... }:
{
  flake.modules.nixos.security =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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
