{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    mpd-mpris
    mpd
    mpc
    playerctl
    rmpc
  ];

  systemd.user.services.mpd = {
    Unit = {
      Description = "Music Player Daemon";
      After = [ "sound.target" "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${config.xdg.configHome}/mpd/mpd.conf";
      Restart = "on-failure";
      RuntimeDirectory = "mpd";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.mpd-mpris = {
    Unit = {
      Description = "MPD MPRIS bridge";
      After = [ "mpd.service" ];
      BindsTo = [ "mpd.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  xdg.configFile."mpd/mpd.conf".text = ''
    music_directory		"/Media/Music"
    playlist_directory	"/Media/Music/playlists"
    db_file			"${config.xdg.configHome}/mpd/mpd.db"
    state_file		"${config.xdg.configHome}/mpd/mpdstate"
    auto_update		"yes"
    bind_to_address		"127.0.0.1"
    bind_to_address		"/run/user/1000/mpd/socket"

    audio_output {
      type		"pulse"
      name		"pulse audio"
    }

    audio_output {
      type		"fifo"
      name		"my_fifo"
      path		"/tmp/mpd.fifo"
      format		"44100:16:2"
    }
  '';

  xdg.configFile."rmpc/config.ron".source = ../config/rmpc/config.ron;
  xdg.configFile."rmpc/themes".source = ../config/rmpc/themes;
  xdg.configFile."rmpc/notify".source = ../config/rmpc/notify;

  home.activation.mpd-dirs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.xdg.configHome}/mpd/playlists
    mkdir -p /Media/Music/playlists
  '';

  home.activation.mpd-start = config.lib.dag.entryAfter [ "mpd-dirs" ] ''
    systemctl --user start mpd.service mpd-mpris.service 2>/dev/null || true
  '';
}
