{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  hashUpdate = import ../lib/hashUpdate.nix;
in
{
  home.packages = [ pkgs.ghostty ];

  home.activation.ensureGhosttyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      ghosttyConfig = pkgs.writeText "ghostty-config" (
        ''
          font-family = DejaVu Sans Mono
          font-size = 11
          window-padding-x = 0
          window-padding-y = 0
          confirm-close-surface = false
        ''
        + lib.optionalString (osConfig.workstation.niri.enable or false) "\ntheme = noctalia\n"
      );
    in
    ''
      ${hashUpdate "ghostty/config" ghosttyConfig}
    ''
  );
}
