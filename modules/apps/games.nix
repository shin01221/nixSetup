{ ... }:
{
  flake.modules.nixos.games =
    {
      pkgs,
      config,
      ...
    }:
    let
      userName = config.workstation.baseline.userName or "shin";
    in
    {
        environment.systemPackages = with pkgs; [
          steam-run
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
    }
  ;
}
