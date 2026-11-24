{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (builtins) readFile;
  hashUpdate = import ../lib/hashUpdate.nix;
in
{
  home.activation.ensureWlrWhichKeyConfig = lib.mkIf (config.workstation.home.niri or false) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        niriYaml = pkgs.writeText "wlr-which-key-niri-yaml" (readFile ../config/wlr-which-key/niri.yaml);
      in
      ''
        ${hashUpdate "wlr-which-key/niri.yaml" niriYaml}
      ''
    )
  );

  home.activation.ensureWlrWhichKeyUmbrielConfig = lib.mkIf (osConfig.workstation.umbriel.enable or false) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        umbrielYaml = pkgs.writeText "wlr-which-key-umbriel-yaml" (readFile ../config/wlr-which-key/umbriel.yaml);
      in
      ''
        ${hashUpdate "wlr-which-key/umbriel.yaml" umbrielYaml}
      ''
    )
  );
}
