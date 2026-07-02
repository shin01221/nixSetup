{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.workstation.media;
  mpvConfig = {
    programs.mpv = {
      enable = true;
      scripts =
        (with pkgs.mpvScripts; [
          sponsorblock
          (videoclip.override { wl-clipboard = pkgs.wl-clipboard-rs; })
          modernz
          thumbfast
        ])
        ++ [
          pkgs.mpvScripts.mpris
        ];

      bindings = {
        "AXIS_UP" = "add volume 2";
        "AXIS_DOWN" = "add volume -2";
        "UP" = "add volume 2";
        "DOWN" = "add volume -2";
        "Shift+RIGHT" = "frame-step";
        "Shift+LEFT" = "frame-back-step";
        "Shift+UP" = "add volume 10";
        "Shift+DOWN" = "add volume -10";
        "y" = "cycle deband";
        "z" = "cycle deband";
        "ctrl+d" = "vf toggle yadif";
        "e" = "add sub-delay +0.042";
        "w" = "add sub-delay -0.042";
        "b" = "add audio-delay +0.042";
        "n" = "add audio-delay -0.042";
        "a" = "cycle-values video-aspect \"16:9\" \"4:3\" \"2.35:1\" \"-1\"";
        "c" = "script-binding videoclip-menu-open";
        MBTN_RIGHT = "script-binding drag-to-pan";
        "alt+down" = "repeatable script-message pan-image y -0.01 yes yes";
        "alt+up" = "repeatable script-message pan-image y +0.01 yes yes";
        "alt+right" = "repeatable script-message pan-image x -0.01 yes yes";
        "alt+left" = "repeatable script-message pan-image x +0.01 yes yes";
      };

      config = {
        osc = "no";
        border = "no";
        msg-color = "yes";
        msg-module = "yes";
        save-watch-history = "yes";
        save-position-on-quit = "yes";
        volume-max = 200;
        hwdec = "auto-safe";
        gpu-api = "opengl";
        profile = "gpu-hq";
        vo = "gpu";
        screenshot-directory = "~/Pictures/Screenshots";
        screenshot-template = "%x/screenshot-%F-%wH.%wM.%wS-F%{estimated-frame-number}";
        screenshot-format = "png";
        screenshot-png-compression = 4;
        screenshot-tag-colorspace = "yes";
        screenshot-high-bit-depth = "yes";
        alang = "en,jpn,jp";
        stop-screensaver = "yes";
        auto-window-resize = "yes";
        keepaspect-window = "no";
        cursor-autohide = 100;
        reset-on-next-file = "video-zoom,panscan,video-unscaled,video-rotate,video-align-x,video-align-y";
      };

      profiles = {
        image = {
          profile-cond = "p[\"current-tracks/video\"] and p[\"current-tracks/video\"].image and not p[\"current-tracks/video\"].albumart";
          profile-restore = "copy-equal";
          include = toString (
            pkgs.writeText "mpv-image-viewer.conf" ''
              script-opts-append=modernz-fade_alpha=50
              script-opts-append=modernz-window_title=yes
              script-opts-append=modernz-bottomhover_zone=50
            ''
          );
          title = "\${media-title} [\${?width:\${width}x\${height}}]";
          taskbar-progress = "no";
          video-unscaled = "yes";
          video-recenter = "yes";
          window-dragging = "no";
          prefetch-playlist = "yes";
          video-aspect-override = "no";
          loop-file = "inf";
          image-display-duration = "inf";
          loop-playlist = "inf";
        };

        video = {
          profile-cond = "p[\"current-tracks/video\"] and not p[\"current-tracks/video\"].image";
          profile-restore = "copy-equal";
          taskbar-progress = "yes";
        };
      };

      scriptOpts = {
        modernz = {
          idlescreen = "no";
          download_path = "~/Videos";
          ontop_button = "no";
          speed_button = "yes";
          info_button = "no";
          fullscreen_button = "no";
          hover_effect = "color";
          hover_effect_color = "#74c7ec";
          seekbarfg_color = "#74c7ec";
          seekbarbg_color = "#181825";
          seek_handle_color = "#74c7ec";
          seek_handle_border_color = "#1e1e2e";
        };

        videoclip = {
          video_folder_path = "~/Videos/clips";
          audio_folder_path = "~/Music/clips";
          video_quality = 10;
          custom_upload_command = "gup -c -s %f";
        };
      };
    };
  };
in
{
  options.workstation.media.enable = lib.mkEnableOption "Media tools (mpv, yt-dlp)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mpv
      yt-dlp
      ff2mpv-rust
      ffmpeg
      playerctl
    ];

    home-manager.sharedModules = [ mpvConfig ];
  };
}
