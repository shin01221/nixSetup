{ pkgs, wm ? "auto" }:
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

    substituteInPlace $out/bin/transparency-toggle.sh \
      --replace-fail 'DEFAULT_WM="auto"' 'DEFAULT_WM="${wm}"'
    chmod +x $out/bin/transparency-toggle.sh
  '';
}
