{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  git,
  maven,
  yarn,
}:
# needs go 1.25.6, but nixpkgs master only has 1.25.5
buildGo126Module (finalAttrs: {
  pname = "git-pkgs";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c8p2hivKylvHJwHB4HLR6qZ99yU7HmjN6bgtUiZX1Mo=";
  };
  vendorHash = "sha256-34mnsapspvyihonNURVUCTLBiFNK0IqpUU2A/tncP8s=";

  ldflags = [
    "-X github.com/git-pkgs/git-pkgs/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags = [
    # tries to access internet
    "-skip TestLicenses"
  ];
  nativeCheckInputs = [
    git
    maven
    yarn
  ];

  postInstall = ''
    mkdir -p $out/share/man
    $out/bin/scripts
    mv man $out/share/man/man1
    rm $out/bin/scripts

    installShellCompletion --cmd git-pkgs \
      --bash <($out/bin/git-pkgs completion bash) \
      --fish <($out/bin/git-pkgs completion fish) \
      --zsh <($out/bin/git-pkgs completion zsh)
  '';

  meta = {
    description = "Track package dependencies across git history";
    homepage = "https://github.com/git-pkgs/git-pkgs";
    license = lib.licenses.mit;
    mainProgram = "git-pkgs";
  };
})
