{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  maven,
  yarn,
}:
buildGoModule (finalAttrs: {
  pname = "git-pkgs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XjW3qwybTmzW2CNgu1Edgs5ZZ9xl3+uS4sT8VWD3jyQ=";
  };
  vendorHash = "sha256-/LJwq17f7SAjSV2ZcLrdaKZYf9RVJ9wtYqEsW0ubT1Q=";

  ldflags = [
    "-X github.com/git-pkgs/git-pkgs/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags = [
    # tries to access internet
    "-skip TestLicensesCommand"
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
