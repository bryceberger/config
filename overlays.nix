{
  system,
  inputs,
}: final: prev: let
  starship = prev.starship.overrideAttrs rec {
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "starship";
      rev = "992516af97cb924e22fb8cc583adf2208326168d";
      hash = "sha256-U8jHJk4TozQD3Z0UFVShYGTcD64yAknZU4o16N7K9z0=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-Y4DzuCEjfQqy5NhupsV+qNm4ji7SBPc79YWfvCm+Wiw=";
    };
  };

  difftastic = prev.difftastic.overrideAttrs rec {
    version = "0.68.0";
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "difftastic";
      rev = "16fb3a078b0e893ca94dc4058686ff8eb43bea7d";
      hash = "sha256-/pY/HiSjvxou2WRcbxDZbI/ASaZgD07ejGde0EQB7X0=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-mEpdIeAESCRaNZ+zAuKWf/0+4npZU8l8jlQdId9tnkA=";
    };
  };

  jj-manage = prev.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "jj-manage";
    version = "0.0.0";

    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "jj-manage";
      rev = "f36eaaf428ea0629e8299840d26179c46c1386cb";
      hash = "sha256-a0BcojtN4Vi8Fvwdv5inuFVjJL/+U7yz5kkgi9OUDW0=";
    };
    cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

    meta.mainProgram = "jj-manage";
  });

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jujutsu = getpackage "jj";
  xilinx-unified = inputs.xilinx-nix-utils.packages.${system}.xilinx-unified-versions."2024.2".xilinx-unified;
  git-pkgs = prev.callPackage ./vendored/git-pkgs/package.nix {
    ruby = prev.ruby_4_0;
  };
  inherit starship difftastic jj-manage;
}
