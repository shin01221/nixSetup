{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "DejaVu Sans Mono:size=10";
        pad = "0x0";
      } // lib.optionalAttrs (osConfig.workstation.niri.enable or false) {
        include = "~/.config/foot/themes/noctalia";
      };
    };
  };
}
