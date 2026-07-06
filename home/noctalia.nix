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

  userTemplates = pkgs.writeText "user-templates" (
    readFile ../config/noctalia/user-templates.toml
  );
in
{
  xdg.configFile."noctalia/palettes".source = ../config/noctalia/palettes;
  xdg.configFile."noctalia/templates".source = ../config/noctalia/templates;

  home.activation.ensureNoctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    ''
      ${hashUpdate "noctalia/noctalia-config.toml" noctaliaConfig}
      ${hashUpdate "noctalia/user-templates.toml" userTemplates}
    ''
  );
}
