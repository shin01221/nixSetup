{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.memory;
in
{
  options.workstation.memory.enable = lib.mkEnableOption "zRAM swap and systemd-oomd";

  config = lib.mkIf cfg.enable {
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
