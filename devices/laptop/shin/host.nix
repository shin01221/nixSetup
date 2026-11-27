{ pkgs, inputs, homeDir, ... }:
{
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelModules = [
    "i2c_hid"
    "hid_multitouch"
  ];

  workstation = {
    baseline.userName = "shin";
    nvidia.prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    network.torProxy.enable = true;
  };

  xdg.portal = {
    extraPortals = [
      inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    config.common."org.freedesktop.impl.portal.FileChooser" = [ "luciole" "gtk" ];
  };

  programs.kdeconnect.enable = true;

  services.openssh.enable = false;
  services.fprintd.enable = false;

  age.identityPaths = [ "${homeDir}/.ssh/agenix_shin" ];

  systemd.services.micmute-led-off = {
    description = "Turn off micmute LED at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "sysinit.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 0 > /sys/class/leds/platform::micmute/brightness || true'";
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    v4l-utils
    podman-compose
    (writeShellScriptBin "docker-compose" ''
      exec ${pkgs.podman-compose}/bin/podman-compose "$@"
    '')
  ];
}
