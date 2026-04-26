{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ups-apply";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "bryceberger";
    repo = "ups";
    rev = "97fe4742d9a574ef56fe58f59232cf9f541ea97c";
    hash = "sha256-rZzjUFp8KP6whRq7OG1KY7/VSiOm8Y5ICwTsFlMKiZI=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  meta.mainProgram = "ups-apply";
})
