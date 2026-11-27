{ ... }:
{
  flake.modules.nixos.themes =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        matugen
        nwg-look
      ];
    };
}
