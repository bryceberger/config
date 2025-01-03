{
  pkgs,
  system,
  inputs,
}: final: prev: let
  make-starship = prev: {
    rev,
    hash,
    cargoHash,
    nativeBuildInputs ? [],
    buildInputs ? [],
  }:
    prev.starship.overrideAttrs (prev: let
      src = pkgs.fetchFromGitHub {
        owner = "bryceberger";
        repo = "starship";
        inherit rev hash;
      };
    in {
      inherit src;
      version = "${prev.version}-${rev}";
      nativeBuildInputs = prev.nativeBuildInputs or [] ++ nativeBuildInputs;
      buildInputs = prev.buildInputs or [] ++ buildInputs;
      cargoDeps = prev.cargoDeps.overrideAttrs {
        inherit src;
        outputHash = cargoHash;
      };
    });

  starship-jj-shell = make-starship prev {
    rev = "jj-shell";
    hash = "sha256-cjdYwBfh1W3mgiAGu7xgcHNLW+/Y1WzflLVJqBEgwqg=";
    cargoHash = "sha256-0n0J9wHzVkyMz8xNBa4vL2YgMBca9Hk5LxmOqhHKR5s=";
  };

  starship-jj-lib = make-starship prev {
    rev = "jj-lib";
    hash = "sha256-sChOgWuL0TOw+3zqYeHUnNW4sttjEZ0h+4Chz0dq20o=";
    cargoHash = "sha256-aqIIahx2iaVkhsz6L8W1oxTiWNmv42JAkBzYxaY4m50=";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl.dev];
  };
in {
  jujutsu = inputs.jj.packages.${system}.default;
  helix = inputs.helix.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;

  ghq = prev.ghq.overrideAttrs (prev: {patches = prev.patches or [] ++ [./pkgs/ghq/default_ssh.patch];});

  starship = starship-jj-shell;
  inherit starship-jj-lib starship-jj-shell;
}
