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
    hash = "";
    cargoHash = "sha256-0n0J9wHzVkyMz8xNBa4vL2YgMBca9Hk5LxmOqhHKR5s=";
  };

  starship-jj-lib = make-starship prev {
    rev = "jj-lib";
    hash = "sha256-tfDu0wZIu96HgvTa1/KOvC/CnKRb5EVnMoSQOS6ViIE=";
    cargoHash = "sha256-c20b/PtbHja+vjLMBl3+eMu/t8hEfrDO/oeZWcaLT1c=";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl.dev];
  };
in {
  jujutsu = inputs.jj.packages.${system}.default;
  helix = inputs.helix.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;

  ghq = prev.ghq.overrideAttrs (prev: {patches = prev.patches or [] ++ [./pkgs/ghq/default_ssh.patch];});

  starship = starship-jj-lib;
  inherit starship-jj-lib starship-jj-shell;
}
