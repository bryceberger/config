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
      hash = "sha256-sChOgWuL0TOw+3zqYeHUnNW4sttjEZ0h+4Chz0dq20o=";
    };
  in {
    inherit src;
    version = "custom";
    nativeBuildInputs = prev.nativeBuildInputs or [] ++ [pkgs.pkg-config];
    buildInputs = prev.buildInputs or [] ++ [pkgs.openssl.dev];
    cargoDeps = prev.cargoDeps.overrideAttrs {
      inherit src;
      outputHash = "sha256-aqIIahx2iaVkhsz6L8W1oxTiWNmv42JAkBzYxaY4m50=";
    };
  });
}
