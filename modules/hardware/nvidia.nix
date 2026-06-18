{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.workstation.nvidia;
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.latest;
in
{
  options.workstation.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";

    prime = {
      amdgpuBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "AMD iGPU PCI Bus ID (e.g. \"PCI:6:0:0\"). Find with `lspci | grep VGA`.";
      };
      nvidiaBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "NVIDIA dGPU PCI Bus ID (e.g. \"PCI:1:0:0\"). Find with `lspci | grep VGA`.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "amdgpu.backlight=0"
    ];

    hardware = {
      nvidia = {
        open = false;
        nvidiaSettings = false;
        powerManagement.enable = true;
        modesetting.enable = true;
        package = nvidiaDriverChannel;
        prime =
          if cfg.prime.amdgpuBusId != null && cfg.prime.nvidiaBusId != null then {
            amdgpuBusId = cfg.prime.amdgpuBusId;
            nvidiaBusId = cfg.prime.nvidiaBusId;
            offload.enable = true;
          } else { };
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
    };

    nixpkgs.config.nvidia.acceptLicense = true;

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/amdgpu_bl0/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/amdgpu_bl0/brightness"
    '';
  };
}
