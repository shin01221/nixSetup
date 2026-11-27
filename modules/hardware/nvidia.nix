{ ... }:
{
  flake.modules.nixos.nvidia =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      # 595.71.05 on stable fails to build against 7.2.6 (missing string.h, see p0d7jd7l...); pull 610.57.04 from unstable via overlay (flake.nix:152)
      # Must match boot.kernelPackages kernel (stable 7.2.6 vs unstable 7.2.6 have different store hashes → vermagic mismatch), so keep kernel also from unstable when using unstable nvidia
      nvidiaDriverChannel = pkgs.unstable.linuxPackages_latest.nvidiaPackages.latest;
    in
    {
      options.workstation.nvidia = {
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

      config = {
        services.xserver.videoDrivers = [
          "amdgpu"
          "nvidia"
        ];

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
              if
                config.workstation.nvidia.prime.amdgpuBusId != null
                && config.workstation.nvidia.prime.nvidiaBusId != null
              then
                {
                  amdgpuBusId = config.workstation.nvidia.prime.amdgpuBusId;
                  nvidiaBusId = config.workstation.nvidia.prime.nvidiaBusId;
                  offload.enable = true;
                }
              else
                { };
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
    };
}
