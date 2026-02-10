{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule {
  pname = "jj-forge";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "bryceberger";
    repo = "jj-forge";
    rev = "64109ef9e8b381baf9963cd905fd0a06f398377a";
    hash = "sha256-8KEPBHeJgVZe7AaZQb+QjeXvkU9B2iDgmDEyJxvTHLQ=";
  };
  vendorHash = "sha256-vHfJp2SRowqwr8nlKAn0yv3X6n6wq/gzH0/c3Uyteyk=";

  nativeBuildInputs = [installShellFiles];

  postInstall = ''
    installShellCompletion --cmd jj-forge \
      --bash <($out/bin/jj-forge completion bash) \
      --fish <($out/bin/jj-forge completion fish) \
      --zsh <($out/bin/jj-forge completion zsh)
  '';

  meta = {
    description = "A translation layer between Jujutsu (jj) and code forges like GitHub.";
    homepage = "https://github.com/msuozzo/jj-forge";
    mainProgram = "jj-forge";
  };
}
