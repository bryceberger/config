{
  system,
  inputs,
}: final: prev: let
  make-starship = prev: args: let
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "starship";
      inherit (args) rev hash;
    };
  in
    prev.callPackage ./pkgs/starship.nix ({
        inherit src;
        pname = "starship-${args.rev}";
        version = "1.22.1";
      }
      // args);

  starship-jj-shell = make-starship prev {
    rev = "jj-shell";
    hash = "sha256-QC5uH94ex+WlB68jbH4W9dmhdM6DVrUSC5NcR+e8efY=";
    cargoHash = "sha256-x94g8iZtVaeKyZDh+HjNaiLcqg4iMWiDLSou+cyP0w4=";
  };

  starship-jj-lib = make-starship prev {
    rev = "jj-lib";
    hash = "sha256-XwOoo+K2eeD2bsVOlTd6+mzC02DIgmJjRwDHzELzErE=";
    cargoHash = "sha256-vaGhBbt78gl0v4xLlaPmuFwJbhLtSRSAn/AsWgtDi+8=";
    nativeBuildInputs = [prev.pkg-config];
    buildInputs = [prev.openssl.dev];
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
