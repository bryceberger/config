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
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    rev = "1a7b7340121d0330fd3fe2d6f1ee9d640a6a75e0";
    hash = "sha256-tK3OviDAZkoKefC44+VqoBoMceE3qkN5+zxBocxa8Zk=";
  };
  vendorHash = "sha256-7ZGVYG+dU0L5nI409vK86l2J1v/8G+G+rzr+lkIp+gU=";

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
    mkdir -p $out/share
    $out/bin/scripts
    mv man $out/share
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
