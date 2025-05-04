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
        pname = "starship-${args.name}";
        version = "1.22.1";
      }
      // args);

  starship-jj-shell = make-starship prev {
    name = "jj-shell";
    rev = "94f8cf562687a60060d6d95936d83dd99cabac6e";
    hash = "sha256-VScMVY9nuCkrGqpH0o00LUN4FJ3SgbhJznoHoi5S66o=";
    cargoHash = "sha256-9Dnw5fWSNrGujDfulLJe7GzUKAKVZQ7vzgMTxkeSr0o=";
  };

  starship-jj-lib = make-starship prev {
    name = "jj-lib";
    rev = "ac39afabae459b833fd32d5ea366184f77fd8aad";
    hash = "sha256-KsvgLjH1vgValAaPrJo3BMv4AtC4ZZPU7Tq+kVnIvNY=";
    cargoHash = "sha256-LAUCkoNh+/+1dEG2vBrV0SCcYK4G1yP5+JzAKLgAQW8=";
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
