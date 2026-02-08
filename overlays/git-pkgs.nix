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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OldlqhgTCPwgBDkcadAKhWeLmWjgPJpmYf99TKniFUY=";
  };
  vendorHash = "sha256-q6J/2OIt09OaK99Q8v3cZNgfleaJfKW0+V7Cd6ib8y8=";

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
