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
      hash = "sha256-jOMFirlqVBWPgJLBeeuV9bqdnoGQm8ZLQy6RWPgqDwY=";
    };
  in {
    inherit src;
    version = "custom";
    cargoDeps = prev.cargoDeps.overrideAttrs {
      inherit src;
      outputHash = "sha256-SVEdajikVyTvjSCTE6SBRXjVsPnUONLP/jitGU5/qfQ=";
    };
  });
}
