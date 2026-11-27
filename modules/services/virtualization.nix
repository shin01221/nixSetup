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
        podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
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

      environment.systemPackages = with pkgs; [
        podman-compose
        (writeShellScriptBin "docker-compose" ''
          exec ${pkgs.podman-compose}/bin/podman-compose "$@"
        '')
      ];
    };
}
