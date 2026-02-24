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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FyeB/mT+YOutjD0rT1pzIU+mKrJYMs2IlbhJ64jC+WA=";
  };
  vendorHash = "sha256-LJEZA369xQgs3XiEeabyO6XVzu9DYkZbyeql5u6h+HM=";

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
    $out/bin/generate-man
    mv man $out/share/man/man1
    rm $out/bin/generate-man $out/bin/generate-docs

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
