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
  jujutsu =
    final.callPackage (final.fetchgit2 {
      url = "https://github.com/jj-vcs/jj";
      revs = [
        # main
        "4d4e52a890257efc7576412ca4b049efc97d828b"
        # annotate --domain
        "d49381db3f302a6325cd23546f12fad72ac68184"
        # log width
        "97b97b9a5ae7c9106c66ec9896645f92335fb03f"
        # revset evaluator
        "84a870a2d05ef528ed73ddb15c558d3a5a343171"
        # default.nix
        "b76a4e8b7b10976df1128563cbf165e4f7f5d856"
        # `jj arrange`
        "1b27d740293c4970619ae9b313fad44bf81b03bd"
      ];
      hash = "sha256-0eVFS/9EfyQWmeJ2zJZzfZiDUhBy0Fn6buEQ+OqUW48=";
    }) {
      gitRev = "0000000000000000000000000000000000000000";
    };

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
