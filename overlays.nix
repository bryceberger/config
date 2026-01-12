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
    version = "0.66.0";
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "difftastic";
      rev = "182565be78d5b0b4a114de276948b4b0d77f6ae8";
      hash = "sha256-8h7EYTGSG0CydAH7+jKgh6ndQ45+Xwb1hybTJyU/p3I=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-3r/4C9J6LHEBD0v7iRotEx2RD7lHiCvnxNnaxT1qOjY=";
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
  git-pkgs = prev.callPackage ./vendored/git-pkgs/package.nix {
    ruby = prev.ruby_4_0;
  };
  inherit starship difftastic jj-manage;
}
