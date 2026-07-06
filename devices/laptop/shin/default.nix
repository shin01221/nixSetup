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
    ../../../modules
  ];

  # hostname
  networking.hostName = "shin";
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelModules = [
    "i2c_hid"
    "hid_multitouch"
  ];

  workstation = {
    baseline = {
      enable = true; # enable baseline config
      userName = "shin";
      packages = {
        tools = true; # enable common suite of CLI tools
        dev = false; # enable common langs/lang related tools
        apps = true; # enable common desktop applications
        themes = true;
      };
    };
    nixvim.enable = true; # enable nixvim configuration
    niri.enable = true; # change to a different profile if you want
    polkit.enable = true;
    yazi.enable = true; # yazi
    virtualization.enable = true; # enable QEMU/KVM virtualization
    nvidia = {
      enable = true;
      prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    games.enable = true; # enable gaming support
    network = {
      enable = true; # enable firewall
      torProxy.enable = true; # enable Tor SOCKS proxy for blocked sites
    };
    security.enable = true; # enable AppArmor
    services.enable = true; # enable fstrim, keyring
    system.enable = true; # enable nix-index-database, GPG agent
    memory.enable = true; # enable zRAM swap + oomd
    media.enable = true;
    audio.enable = true;
    touchpad.enable = true;
    sound.enable = true;
    zen.enable = true;
    tuning.tlp.enable = true;

    # Home-manager toggles (all opt-in)
    home = {
      fish = true;
      scripts = true;
      theming = true;
      tmux = {
        enable = true;
        sessionx.enable = false;
      };
      spotify = true;
      xdg = true;
      obs-studio = true;
      foot = true;
      ghostty = true;
      dolphin = true;
      niri = true;
      noctalia = true;
      wlr-which-key = true;
      audio = true;
    };

    # flatpak = {
    #   enable = true;
    #   onCalendar = "weekly";
    #   packages = [ ];
    # };
  };

  # tmux: enable all plugins except sessionx on this host
  # (moved to tmux.nix until we add a proper workstation.tmux option)

  services.openssh.enable = false;
  services.fprintd.enable = false;

  age.identityPaths = [ "/home/shin/.ssh/agenix_shin" ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "pnpm-10.29.2" # build-time dep for heroic, vesktop - revisit when nixpkgs updates pnpm
  # ];

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
