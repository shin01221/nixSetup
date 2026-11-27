{ ... }:
{
  flake.modules.nixos.luciole =
    { pkgs, inputs, ... }:
    {
      xdg.portal = {
        extraPortals = [
          inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
        config.common."org.freedesktop.impl.portal.FileChooser" = [ "luciole" "gtk" ];
      };
    };
}
