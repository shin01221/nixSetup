{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.workstation.games;
  userName = config.workstation.baseline.userName or "gumbo";
in
{
  options.workstation.games.enable = lib.mkEnableOption "Gaming support (Steam, GameMode, MangoHud, Gamescope)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic
      lutris
      steam-run
      wineWow64Packages.staging
    ];

    users.users.${userName}.extraGroups = [ "gamemode" ];

    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
            ioprio = 0;
            inhibit_screensaver = 1;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
          };
        };
      };

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };

    home-manager.sharedModules = [
      (_: {
        programs.mangohud = {
          enable = true;
          enableSessionWide = true;
          settings = {
            no_display = true;
            fps_limit = [ 60 0 144 165 240 ];
            fps_limit_method = "late";
            vsync = 2;
            gl_vsync = 1;
            toggle_hud = "Shift_R+F12";
            toggle_fps_limit = "Shift_R+F1";
            fps = true;
            show_fps_limit = true;
            frametime = true;
            frame_timing = true;
            present_mode = true;
            cpu_stats = true;
            cpu_temp = true;
            cpu_power = true;
            cpu_mhz = true;
            gpu_stats = true;
            gpu_temp = true;
            gpu_core_clock = true;
            gpu_mem_clock = true;
            gpu_power = true;
            vram = true;
            throttling_status = true;
            ram = true;
          };
        };
      })
    ];
  };
}
