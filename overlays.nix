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
    args.version = "0.69.0";
    rev = "07832cea0f8cccc4b2e75b10a75403af3fe7225c";
    hash = "sha256-EDxqFjpC33Ahrz+cEpq8194FrWIvGZqbV4PNbZ9qnOY=";
    cargoHash = "sha256-zp/gS02uTmix75G73o2l6UtFmkMaRPUbXmbzjGPahMg=";
  };
  starship = overrideRust {
    pkg = "starship";
    rev = "e8a91648f34c0b15cb5d7d634ca8eb600fa7c3e3";
    hash = "sha256-aaDyO8t+hGmcvFudVntn4MTUm9msS0XB2VjkX5Ku5cU=";
    cargoHash = "sha256-22UWJ8cwnIkwa1tmvbUvEupIlXGjU81cDy2Ns7kJVqI=";
  };

  git-pkgs = final.callPackage ./overlays/git-pkgs.nix {};
  jj-forge = final.callPackage ./overlays/jj-forge.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};
}
