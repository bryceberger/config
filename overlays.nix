{
  pkgs,
  system,
  inputs,
}: final: prev: {
  jujutsu = inputs.jj.packages.${system}.default;
  helix = inputs.helix.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;

  ghq = prev.ghq.overrideAttrs (prev: {patches = prev.patches or [] ++ [./pkgs/ghq/default_ssh.patch];});
  starship = prev.starship.overrideAttrs (prev: let
    src = pkgs.fetchFromGitHub {
      owner = "bryceberger";
      repo = "starship";
      rev = "personal";
      hash = "sha256-bbzepF59X2hgLV6cJgfWQyHZbImFzKYTP+NoU/gBrsQ=";
    };
  in {
    inherit src;
    version = "custom";
    cargoDeps = prev.cargoDeps.overrideAttrs {
      inherit src;
      outputHash = "sha256-+2MfLce5sY4bJcilFuYX3RdADomDP3eUAAC65/Dfm+0=";
    };
  });
}
