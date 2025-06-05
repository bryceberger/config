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

  difft = prev.difftastic.overrideAttrs (old: rec {
    version = "0.64.0";
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "difftastic";
      # https://github.com/Wilfred/difftastic/pull/842
      rev = "7f7313e66dce19d064a15f178900df049fc6fa76";
      hash = "sha256-PWcJO9YRaWBCKkd3m6bfzR9Zz8diXOEml6/BCzWSQNA=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-QWwNU4vOA6jWVb9rHJED/VDhwMFPZCKA4Ajad3W1czw=";
    };
  });

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jj-manage = getpackage "jj-manage";
  jujutsu = getpackage "jj";

  starship = starship-jj-lib;
  inherit starship-jj-lib starship-jj-shell;

  difftastic = difft;
}
