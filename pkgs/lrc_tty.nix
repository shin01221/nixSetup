{ lib, stdenv, fetchFromGitHub, zig_0_15, dbus, pkg-config }:

stdenv.mkDerivation (finalAttrs: {
  pname = "lrc_tty";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "larsgrah";
    repo = "lrc_tty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UMaE0Ke6Izr615BzLqhiFM8A6QDu5SUSXFEotqoMRLk=";
  };

  nativeBuildInputs = [ zig_0_15 pkg-config ];
  buildInputs = [ dbus ];

  buildPhase = ''
    zig build install -Doptimize=ReleaseSafe --prefix $out
  '';

  meta = {
    description = "Terminal lyric viewer for any MPRIS-compatible player";
    homepage = "https://github.com/larsgrah/lrc_tty";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
})
