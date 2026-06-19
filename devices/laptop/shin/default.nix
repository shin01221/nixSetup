{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/baseline.nix

    ../../../modules/flatpak.nix
    ../../../modules/niri.nix
    ../../../modules/nixvim.nix
    ../../../modules/packages.nix
    ../../../modules/yazi.nix
    ../../../modules/virtualization.nix
    ../../../modules/polkit.nix
    ../../../modules/audio
    ../../../modules/hardware/nvidia.nix
    ../../../modules/hardware/touchpad.nix
    ../../../modules/hardware/media/sound.nix
    ../../../modules/games
    ../../../modules/network
    ../../../modules/security
    ../../../modules/services
    ../../../modules/system
    ../../../modules/memory
    ../../../modules/tuning/tlp
    ../../../modules/media
  ];

  # hostname
  networking.hostName = "shin";
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelModules = [ "i2c_hid" "hid_multitouch" ];

  workstation = {
    baseline = {
      enable = true;              # enable baseline config
      userName = "shin";
      packages = {
        tools = true;             # enable common suite of CLI tools
        dev = false;               # enable common langs/lang related tools
        apps = true;              # enable common desktop applications
        themes = true;
      };
    }; 
    nixvim.enable = true;         # enable nixvim configuration
    niri.enable = true;           # change to a different profile if you want
    polkit.enable = true;
    yazi.enable = true;           # yazi
    virtualization.enable = true; # enable QEMU/KVM virtualization
    nvidia = {
      enable = true;
      prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    games.enable = true;          # enable gaming support
    network.enable = true;        # enable firewall
    security.enable = true;       # enable AppArmor
    services.enable = true;       # enable fstrim, keyring
    system.enable = true;         # enable nix-index-database, GPG agent
    memory.enable = true;         # enable zRAM swap + oomd
    media.enable = true;

    flatpak = {
      enable = true;
      onCalendar = "weekly";
      packages = [
        "flathub:app/app.zen_browser.zen//stable"
      ];
    };
  };

  services.openssh.enable = false;
  services.fprintd.enable = false;

  age.identityPaths = [ "/home/shin/.ssh/agenix_shin" ];
  
  # symlink agenix key so I can use it in cli
  # system.activationScripts.agenix-cli-identity = ''
  #   mkdir -p /home/shin/.ssh
  #   if [ ! -e /home/shin/.ssh/id_ed25519 ]; then
  #     ln -s agenix_shin /home/shin/.ssh/id_ed25519
  #   fi
  # '';

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
  };

  environment.systemPackages = with pkgs; [
    v4l-utils
  ];
}
