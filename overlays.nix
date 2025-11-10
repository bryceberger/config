{
  system,
  inputs,
}: final: prev: let
  starship = prev.starship.overrideAttrs rec {
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "starship";
      rev = "b157f578b1709f0b8b84669da209e44ee23618ae";
      hash = "sha256-K6YwOpuIQtG2Ezp1JdrRBXQgP8Jn910xHl6z9s+hkrc=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-At8SaAgRvx6MssHuXSaZJQg9HAel/SJPJV6UFdRhATg=";
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
      rev = "d0d4f94e89f88264e7c8e143e3f4cf87704c3606";
      hash = "sha256-iOhStnftTUisf5nntGH5AH3Fyo3tRuivcKOXbiEWBHI=";
    };
    cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

    meta.mainProgram = "jj-manage";
  });

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jujutsu = getpackage "jj";
  inherit starship difftastic jj-manage;
}
