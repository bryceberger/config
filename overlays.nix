{
  system,
  inputs,
}: final: prev: let
  starship = prev.starship.overrideAttrs rec {
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "starship";
      rev = "b9a8924d8cf60b6846abf9cdc7dc9bdd518c08b0";
      hash = "sha256-UsjPTqLASxznlGB/Z95k7r0B+NbxNN/xo9bd0CC0ZyI=";
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

  git-pkgs = prev.buildGoModule rec {
    pname = "git-pkgs";
    version = "0.10.4";

    src = prev.fetchFromGitHub {
      owner = "git-pkgs";
      repo = "git-pkgs";
      rev = "f49e36a86ea7019e16933c2e4fdc4f8dc7fc7a87";
      hash = "sha256-RKmhzmBKDaRPbzDV8dAp5gSGLqhzz6Wh4s0F3e+GOig=";
    };
    vendorHash = "sha256-ZSMou+S6pT/xSqnU1CPQcymmeASydpR98ukEKUKX8lw=";

    ldflags = [
      "-X github.com/git-pkgs/git-pkgs/cmd.version=${version}"
    ];

    # tries to access internet during tests
    doCheck = false;
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
  inherit
    difftastic
    git-pkgs
    jj-manage
    starship
    ;
}
