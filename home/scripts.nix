{ ... }:
{
  flake.modules.homeManager.scripts =
    { pkgs, lib, hostFeatures, ... }:
    let
      wm =
        if builtins.elem "umbriel" hostFeatures then
          "umbriel"
        else if builtins.elem "niri" hostFeatures then
          "niri"
        else
          "auto";

      enablePowerToggle =
        builtins.elem "noctalia" hostFeatures
        && (builtins.elem "umbriel" hostFeatures || builtins.elem "niri" hostFeatures);

      scripts = pkgs.callPackage ../pkgs/scripts { inherit wm enablePowerToggle; };
    in
    {
      home.packages = [ scripts ];

      systemd.user.services.power-toggle = lib.mkIf enablePowerToggle {
        Unit = {
          Description = "Toggle compositor animations and blur based on AC power";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          StartLimitIntervalSec = 0;
        };
        Service = {
          ExecStart = "${scripts}/bin/power-toggle watch";
          Restart = "always";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    }
  ;
}
