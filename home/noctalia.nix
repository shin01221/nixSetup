{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) readFile;
  hashUpdate = import ../lib/hashUpdate.nix;

  noctaliaConfig = pkgs.writeText "noctalia-config" (
    readFile ../config/noctalia/noctalia-config.toml
  );
in
{
  xdg.configFile."noctalia/palettes".source = ../config/noctalia/palettes;
  xdg.configFile."noctalia/templates".source = ../config/noctalia/templates;
  xdg.configFile."noctalia/user-templates.toml".source = ../config/noctalia/user-templates.toml;

  home.activation.ensureNoctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (''
    ${hashUpdate "noctalia/noctalia-config.toml" noctaliaConfig}
  '');
}
