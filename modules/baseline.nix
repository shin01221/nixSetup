# Note that baseline packages are now in ./packages.nix, and nested into the workstation.baseline module
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.baseline;
  userName = cfg.userName;
in
{
  options.workstation.baseline = {
    enable = lib.mkEnableOption "Baseline workstation configuration";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "gumbo";
      description = "Primary user account name";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    boot = {
      tmp.cleanOnBoot = true;

      kernel.sysctl."vm.swappiness" = 100;

      kernelParams = [ "preempt=full" ];

      loader = {
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "auto";
        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = "/boot";
        timeout = 10;
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "uvcvideo" ];
    };

    hardware.enableAllFirmware = true;

    networking.networkmanager.enable = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    time.timeZone = "Africa/Cairo";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    users.users.${userName} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
        "sound"
        "video"
        "audio"
        "libvirtd"
        "borg"
      ];
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = false;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        inter
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [
            "Inter"
            "Noto Sans"
          ];
          serif = [ "Noto Serif" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
      fontDir.enable = true;
    };

    programs.dconf.enable = true;

    programs.fish.enable = true;

    services = {
      tailscale.enable = true;
      pcscd.enable = true; # yubikey dep
      libinput.enable = true;
      upower.enable = true;
      # power-profiles-daemon.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };
    };
    security.rtkit.enable = true;
    
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    system.stateVersion = "25.05";
  };
}
