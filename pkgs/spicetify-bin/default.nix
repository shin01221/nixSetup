{ lib, stdenvNoCC, fetchurl }:

let
  version = "2.44.0";
  sources = {
    x86_64-linux = {
      url = "https://github.com/spicetify/cli/releases/download/v${version}/spicetify-${version}-linux-amd64.tar.gz";
      hash = "sha256-EVBFYQpgmiCErzieZapPYDUaS47xSXzpi9vfN5VE75s=";
    };
  };
  src = fetchurl sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "spicetify-bin";
  inherit version src;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/spicetify $out/bin
    cp spicetify $out/share/spicetify/
    cp -r jsHelper $out/share/spicetify/
    cp css-map.json $out/share/spicetify/
    cp -r Themes $out/share/spicetify/ 2>/dev/null || true
    cp -r Extensions $out/share/spicetify/ 2>/dev/null || true
    cp -r CustomApps $out/share/spicetify/ 2>/dev/null || true
    ln -s $out/share/spicetify/spicetify $out/bin/spicetify
    runHook postInstall
  '';

  meta = {
    description = "Command-line tool to customize Spotify client (pre-built binary)";
    homepage = "https://github.com/spicetify/cli";
    license = lib.licenses.lgpl21Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "spicetify";
  };
}
