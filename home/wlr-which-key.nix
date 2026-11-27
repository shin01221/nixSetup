{ ... }:
{
  flake.modules.homeManager.wlr-which-key =
    {
      config,
      pkgs,
      lib,
      hostFeatures,
      ...
    }:
    let
      inherit (builtins) readFile;
      hashUpdate = import ../lib/hashUpdate.nix;
    in
    {
      home.activation.ensureWlrWhichKeyConfig = lib.mkIf (builtins.elem "niri" hostFeatures) (
        lib.hm.dag.entryAfter [ "writeBoundary" ] (
          let
            niriYaml = pkgs.writeText "wlr-which-key-niri-yaml" (readFile ../config/wlr-which-key/niri.yaml);
          in
          ''
            ${hashUpdate "wlr-which-key/niri.yaml" niriYaml}
          ''
        )
      );

      home.activation.ensureWlrWhichKeyUmbrielConfig = lib.mkIf (builtins.elem "umbriel" hostFeatures) (
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
  ;
}
