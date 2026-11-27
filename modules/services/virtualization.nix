{ ... }:
{
  flake.modules.nixos.virtualization =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      programs.virt-manager.enable = true;
      virtualisation = {
        libvirtd = {
          enable = true;
          allowedBridges = [
            "virbr0"
            "br0"
          ];
          qemu = {
            swtpm.enable = true;
            package = pkgs.qemu.override {
              gtkSupport = true;
              openGLSupport = true;
              virglSupport = true;
            };
          };
        };
        spiceUSBRedirection.enable = true;
      };

      services = {
        qemuGuest.enable = true;
        spice-vdagentd.enable = true;
      };
    };
}
