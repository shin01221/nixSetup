{ ... }:
{
  flake.modules.homeManager.foot =
    {
      config,
      pkgs,
      lib,
      hostFeatures,
      ...
    }:
    {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "DejaVu Sans Mono:size=10";
            pad = "0x0";
          } // lib.optionalAttrs (builtins.elem "niri" hostFeatures) {
            include = "~/.config/foot/themes/noctalia";
          } // lib.optionalAttrs (builtins.elem "umbriel" hostFeatures) {
            include = "~/.config/foot/themes/noctalia";
          };
        };
      };
    }
  ;
}
