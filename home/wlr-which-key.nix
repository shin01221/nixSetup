{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) readFile dirOf baseNameOf;

  hashUpdate =
    target: storePath:
    let
      dir = dirOf target;
      base = baseNameOf target;
    in
    ''
      hash_file="$HOME/.config/${dir}/.${base}.hash"
      full_target="$HOME/.config/${target}"
      store="${storePath}"

      if [ ! -f "$full_target" ] || [ ! -f "$hash_file" ]; then
        install -Dm644 "$store" "$full_target"
        store_hash=$(md5sum "$store" | cut -d' ' -f1)
        echo "$store_hash" > "$hash_file"
      else
        expected=$(cat "$hash_file")
        current=$(md5sum "$full_target" | cut -d' ' -f1)
        store_hash=$(md5sum "$store" | cut -d' ' -f1)
        if [ "$expected" = "$current" ] && [ "$store_hash" != "$current" ]; then
          install -Dm644 "$store" "$full_target"
          echo "$store_hash" > "$hash_file"
        fi
      fi
    '';
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
