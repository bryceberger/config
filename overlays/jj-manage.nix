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
    rev = "f36eaaf428ea0629e8299840d26179c46c1386cb";
    hash = "sha256-a0BcojtN4Vi8Fvwdv5inuFVjJL/+U7yz5kkgi9OUDW0=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  meta.mainProgram = "jj-manage";
})
