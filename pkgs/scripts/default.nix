{ pkgs, wm ? "auto", enablePowerToggle ? true }:
let
  lib = pkgs.lib;

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
      name="$(basename "$f")"
      [ "$name" = "default.nix" ] && continue
      ${lib.optionalString (!enablePowerToggle) ''
      [ "$name" = "power-toggle" ] && continue
      ''}
      cp -a "$f" $out/bin/
    done

    substituteInPlace $out/bin/transparency-toggle.sh \
      --replace-fail 'DEFAULT_WM="auto"' 'DEFAULT_WM="${wm}"'
    chmod +x $out/bin/transparency-toggle.sh

    wrapProgram $out/bin/wallpaper-history.sh \
      --prefix PATH : ${lib.makeBinPath wallpaperHistoryDeps}

    wrapProgram $out/bin/router-new-ip \
      --prefix PATH : ${lib.makeBinPath [ pkgs.python3 ]}
  '';
}
