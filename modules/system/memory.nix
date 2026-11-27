{ ... }:
{
  flake.modules.nixos.memory =
    {
      config,
      lib,
      ...
    }:
    {
      zramSwap = {
        enable = true;
        memoryPercent = 100;
        algorithm = "zstd";
      };

      systemd.oomd = {
        enable = true;
        enableUserSlices = true;
      };

      systemd.slices."user" = {
        sliceConfig = {
          ManagedOOMMemoryPressure = "kill";
          ManagedOOMMemoryPressureLimit = "90%";
        };
      };
    };
}
