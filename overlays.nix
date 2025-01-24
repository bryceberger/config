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
    hash = "sha256-AQynP1HfqWTabX/VDgqeh69bEasRHpDm/50HcTmWhSg=";
    cargoHash = "sha256-0xq4Ya4KBK4cF+gV6tncHpk2LHVwWc9NN3SM7K/pgVY=";
  };

  starship-jj-lib = make-starship prev {
    rev = "jj-lib";
    hash = "sha256-NvnW2RyCNTqv0i0LlQckTV4F2sEZ97ova4FMlskyhC0=";
    cargoHash = "sha256-WmhfD+9Vv2Eh3pETthqMtTZD7ABPbeeK4I46kONVHb8=";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.openssl.dev];
  };

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  gh-dash = getpackage "gh-dash";
  helix = getpackage "helix";
  jj-manage = getpackage "jj-manage";
  jujutsu = getpackage "jj";
  zen-browser = getpackage "zen-browser";

  starship = starship-jj-lib;
  inherit starship-jj-lib starship-jj-shell;
}
