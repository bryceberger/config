{
  system,
  inputs,
}: final: prev: let
  starship = prev.starship.overrideAttrs rec {
    src = final.fetchFromGitHub {
      owner = "bryceberger";
      repo = "starship";
      rev = "b9a8924d8cf60b6846abf9cdc7dc9bdd518c08b0";
      hash = "sha256-UsjPTqLASxznlGB/Z95k7r0B+NbxNN/xo9bd0CC0ZyI=";
    };
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-Y4DzuCEjfQqy5NhupsV+qNm4ji7SBPc79YWfvCm+Wiw=";
    };
  };

  difftastic = prev.difftastic.overrideAttrs rec {
    version = "0.68.0";
    src = final.fetchFromGitHub {
      owner = "bryceberger";
      repo = "difftastic";
      rev = "16fb3a078b0e893ca94dc4058686ff8eb43bea7d";
      hash = "sha256-/pY/HiSjvxou2WRcbxDZbI/ASaZgD07ejGde0EQB7X0=";
    };
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-mEpdIeAESCRaNZ+zAuKWf/0+4npZU8l8jlQdId9tnkA=";
    };
  };

  git-pkgs = final.callPackage ./overlays/git-pkgs.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jujutsu = getpackage "jj";
  inherit
    difftastic
    git-pkgs
    jj-manage
    starship
    ;
}
