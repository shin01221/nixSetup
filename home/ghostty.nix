{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (builtins) dirOf baseNameOf;

  hashUpdate = target: storePath: let
    dir = dirOf target;
    base = baseNameOf target;
  in ''
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
  home.packages = [ pkgs.ghostty ];

  home.activation.ensureGhosttyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      ghosttyConfig = pkgs.writeText "ghostty-config" (
        ''
          font-family = DejaVu Sans Mono
          font-size = 10
          window-padding-x = 14
          window-padding-y = 14
          confirm-close-surface = false
        '' + lib.optionalString (osConfig.workstation.niri.enable or false) "\ntheme = noctalia\n"
      );
    in
    ''
      ${hashUpdate "ghostty/config" ghosttyConfig}
    ''
  );
}
