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
    rev = "4f104b203349ee73a759b2519f283ad1ab47ec51";
    hash = "sha256-3HS0ofgXrOjEjOGM9xRWAT1ZiEZWXxpqf9CAyRBWTyw=";
    cargoHash = "sha256-jh1hLj7UejFm7Z6e9UKTc7ACFni0HdMwky0CYmMBgGU=";
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
