{ pkgs, homeDir, ... }:
{
  hardware.cpu.amd.updateMicrocode = true;

  workstation = {
    nvidia.prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    network.torProxy.enable = true;
  };

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
}
