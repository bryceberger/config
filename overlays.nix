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
    hash = "sha256-km90IKHPHGTlHnhIb9O7K3tZjKf/fS/qJs+CRVOuZ/8=";
    cargoHash = "sha256-KIgCDmkj6pSTtWOnWWIiYmo2JOq5C9osv+BJDYQ7utY=";
  };

  starship-jj-lib = make-starship prev {
    rev = "jj-lib";
    hash = "sha256-HGeTJzA19xTxN/VAZUcbq6avPVN7m9obGfpJfUvUF38=";
    cargoHash = "sha256-ZnCG/x9oHOYF8kwv2P10W7dtgZXygeEoYQ57H8YSe5U=";
    nativeBuildInputs = [prev.pkg-config];
    buildInputs = [prev.openssl.dev];
  };

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jj-manage = getpackage "jj-manage";
  jujutsu = getpackage "jj";

  starship = starship-jj-lib;
  inherit starship-jj-lib starship-jj-shell;
}
