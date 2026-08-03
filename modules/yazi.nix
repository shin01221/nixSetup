{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.yazi;
in
{

  options.workstation.yazi.enable = lib.mkEnableOption "Yazi configuration";

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      settings = {
        yazi = {
          ratio = [
            1
            4
            3
          ];
          sort-by = "natural";
          sort-sensitive = true;
          sort-reverse = false;
          sort-dir-first = true;
          linemode = "none";
          show-hidden = "show";
          show-symlink = "show";
        };
      };
    };
  };
}
