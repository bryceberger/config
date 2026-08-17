{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  asciidoc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "streampager";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "markbt";
    repo = "streampager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xOFm/tjZBkkUa/Q5SStZSX++oTgd+ncY47dg5Ryvjo4=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  nativeBuildInputs = [
    installShellFiles
    asciidoc
  ];

  postInstall = ''
    mkdir -p $out/share/man
    sp=$(find \
      ./target/x86_64-unknown-linux-gnu/release/build/ \
      -type d -maxdepth 1 -regex ".*/streampager-.*")
    cp "$sp/out/sp.1.txt" "$out/share/man/"
    installShellCompletion --cmd sp \
      --bash "$sp/out/sp.bash" \
      --fish "$sp/out/sp.fish" \
      --zsh "$sp/out/_sp"
  '';

  meta = {
    description = "A pager for command output or large files";
    homepage = "https://github.com/markbt/streampager";
    license = lib.licenses.mit;
    mainProgram = "sp";
  };
})
