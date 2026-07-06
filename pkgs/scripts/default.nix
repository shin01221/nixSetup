{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "my-scripts";
  src = ./.;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    for f in $src/*; do
      [ "$(basename "$f")" = "default.nix" ] && continue
      cp -a "$f" $out/bin/
    done
  '';
}
