{ ... }:
{
  flake.modules.homeManager.games =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (pkgs.callPackage ../pkgs/nvidia-offload { })
        heroic
        lutris
        wineWow64Packages.staging
      ];

      programs.mangohud = {
        enable = true;
        settings = {
          position = "bottom-right";
          font_size = 12;
          fps_limit = [
            60
            120
          ];
          fps_limit_method = "late";
          vsync = 2;
          gl_vsync = 1;
          toggle_hud = "Shift_R+F12";
          toggle_fps_limit = "Shift_R+F1";
          fps = true;
          cpu_stats = true;
          cpu_temp = true;
          cpu_mhz = true;
          gpu_stats = true;
          gpu_temp = true;
          vram = true;
          throttling_status = true;
          ram = true;
        };
      };
    };
}
