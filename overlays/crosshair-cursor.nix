{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "crosshair-cursor";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "ryanwarfield";
    repo = "crosshair-cursor";
    rev = "v${version}";
    hash = "sha256-m3N5/eh6LjqQl6a0viqJKtQWTAl0rFJWGvgvS1aDvl4=";
  };

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr crosshair-cursors $out/share/icons/crosshair-cursor
  '';

  meta = {
    homepage = "https://github.com/ryanwarfield/crosshair-cursor";
    platforms = lib.platforms.linux;
  };
}
