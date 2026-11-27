{ ... }:
{
  flake.modules.nixos.nixvim = {
    imports = [ ./_nixvim ];
    workstation.nixvim.enable = true;
  };
}
