{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-manage";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "bryceberger";
    repo = "jj-manage";
    rev = "e4ac8585e848538a42d8b3280a6b514846c834c7";
    hash = "sha256-mVqfzMtrfUBS9AYncQ0pxnnTuGfQ1kLZlsQFVD63E7A=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  meta.mainProgram = "jj-manage";
})
