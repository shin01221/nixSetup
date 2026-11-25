{ pkgs, wm ? "auto" }:
let
  wallpaperHistoryDeps = with pkgs; [
    sqlite
    fzf
    chafa
    file
    libnotify
    coreutils
    findutils
  ];
in
pkgs.stdenv.mkDerivation {
  name = "my-scripts";
  src = ./.;
  dontBuild = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    for f in $src/*; do
      [ "$(basename "$f")" = "default.nix" ] && continue
      cp -a "$f" $out/bin/
    done

    substituteInPlace $out/bin/transparency-toggle.sh \
      --replace-fail 'DEFAULT_WM="auto"' 'DEFAULT_WM="${wm}"'
    chmod +x $out/bin/transparency-toggle.sh

    wrapProgram $out/bin/wallpaper-history.sh \
      --prefix PATH : ${pkgs.lib.makeBinPath wallpaperHistoryDeps}
  '';
}
