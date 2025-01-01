{
  pkgs,
  system,
  inputs,
}: final: prev: {
  jujutsu = inputs.jj.packages.${system}.jujutsu;
  helix = inputs.helix.packages.${system}.helix;

  zen-browser-unwrapped = prev.callPackage ./pkgs/zen-browser-unwrapped/package.nix {};
  zen-browser = final.callPackage ./pkgs/zen-browser/package.nix {};

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
