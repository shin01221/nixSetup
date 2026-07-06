{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) readFile;
  hashUpdate = import ../lib/hashUpdate.nix;
in
{
  home.activation.ensureWlrWhichKeyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      niriYaml = pkgs.writeText "wlr-which-key-niri-yaml" (readFile ../config/wlr-which-key/niri.yaml);
    in
    ''
      ${hashUpdate "wlr-which-key/niri.yaml" niriYaml}
    ''
  );
}
