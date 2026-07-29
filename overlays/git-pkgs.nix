# nix run .#pkgs.nix-update -- --flake git-pkgs
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
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C4T4xkNrMIMuRLhua0fTXDpIz0qq5EaqVnSKWUc7Sm0=";
  };
  vendorHash = "sha256-d5Me/VgXXC2FyxG17rXg1FmOIi1fJqBmBU+bF5u0j/8=";

  ldflags = [
    "-X github.com/git-pkgs/git-pkgs/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
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
