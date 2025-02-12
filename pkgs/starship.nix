{
  lib,
  stdenv,
  rustPlatform,
  installShellFiles,
  cmake,
  git,
  buildInputs ? [],
  nativeBuildInputs ? [],
  pname,
  version,
  src,
  cargoHash,
  ...
}:
rustPlatform.buildRustPackage {
  inherit pname version src cargoHash;

  nativeBuildInputs = nativeBuildInputs ++ [installShellFiles cmake];
  inherit buildInputs;

  NIX_LDFLAGS = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-framework"
    "AppKit"
  ];

  # tries to access HOME only in aarch64-darwin environment when building mac-notification-sys
  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    export HOME=$TMPDIR
  '';

  postInstall =
    ''
      presetdir=$out/share/starship/presets/
      mkdir -p $presetdir
      cp docs/public/presets/toml/*.toml $presetdir
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd starship \
        --bash <($out/bin/starship completions bash) \
        --fish <($out/bin/starship completions fish) \
        --zsh <($out/bin/starship completions zsh)
    '';

  useFetchCargoVendor = true;

  nativeCheckInputs = [git];
  preCheck = ''
    HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    mainProgram = "starship";
  };
}
