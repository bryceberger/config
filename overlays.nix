{
  system,
  inputs,
}: final: prev: let
  overrideRust = {
    pkg,
    owner ? "bryceberger",
    repo ? pkg,
    rev,
    hash,
    cargoHash,
    args ? {},
  }: let
    src = final.fetchFromGitHub {inherit owner repo rev hash;};
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = cargoHash;
    };
  in
    prev."${pkg}".overrideAttrs (args // {inherit src cargoDeps;});

  getInput = package: inputs.${package}.packages.${system}.default;
in {
  helix = getInput "helix";
  jujutsu = getInput "jj";

  difftastic = overrideRust {
    pkg = "difftastic";
    args.version = "0.68.0";
    rev = "16fb3a078b0e893ca94dc4058686ff8eb43bea7d";
    hash = "sha256-/pY/HiSjvxou2WRcbxDZbI/ASaZgD07ejGde0EQB7X0=";
    cargoHash = "sha256-mEpdIeAESCRaNZ+zAuKWf/0+4npZU8l8jlQdId9tnkA=";
  };
  starship = overrideRust {
    pkg = "starship";
    rev = "b9a8924d8cf60b6846abf9cdc7dc9bdd518c08b0";
    hash = "sha256-UsjPTqLASxznlGB/Z95k7r0B+NbxNN/xo9bd0CC0ZyI=";
    cargoHash = "sha256-Y4DzuCEjfQqy5NhupsV+qNm4ji7SBPc79YWfvCm+Wiw=";
  };

  git-pkgs = final.callPackage ./overlays/git-pkgs.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};
}
