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
    rev = "e8a91648f34c0b15cb5d7d634ca8eb600fa7c3e3";
    hash = "sha256-aaDyO8t+hGmcvFudVntn4MTUm9msS0XB2VjkX5Ku5cU=";
    cargoHash = "sha256-22UWJ8cwnIkwa1tmvbUvEupIlXGjU81cDy2Ns7kJVqI=";
  };

  fetchgit2 = final.callPackage ./overlays/fetchgit2 {};
  git-pkgs = final.callPackage ./overlays/git-pkgs.nix {};
  jj-forge = final.callPackage ./overlays/jj-forge.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};
}
