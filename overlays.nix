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
    rev = "8192e458499ab3b253e7522addc9523be4e24314";
    hash = "sha256-km90IKHPHGTlHnhIb9O7K3tZjKf/fS/qJs+CRVOuZ/8=";
    cargoHash = "sha256-KIgCDmkj6pSTtWOnWWIiYmo2JOq5C9osv+BJDYQ7utY=";
  };

  starship-jj-lib = make-starship prev {
    name = "jj-lib";
    rev = "c6d342847af28a5021ad3e083e613365ab54ece3";
    hash = "sha256-BO3lj8RZeqirMuwkQgP2HsIUmqkzr0J2QTydZQ7UFPE=";
    cargoHash = "sha256-MOXaGgkttXoBA8+HPPNmhJdSC2bfIsV3e1EVgXDqnrg=";
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
