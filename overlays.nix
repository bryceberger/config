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
    version = "0.65.0";
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "difftastic";
      rev = "bca3188cb265cf62be914c8c8261a8edb5ee7ad4";
      hash = "sha256-RWZApCeWm2xEg6fnScMU9PjcoGhO5r1gLXYqGpUJifY=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-NenCGFTMDlXaXv0gRLA66gGWehFgUGEMBRJvFbjk+NU=";
    };
  };

  jj-manage = prev.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "jj-manage";
    version = "0.0.0";

    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "jj-manage";
      rev = "d57271a1607ee24c46156a5052a2b899a82892dc";
      hash = "sha256-tnv6pGlOZr2eqXo37sl6vQUCJTSaD1Tm40UaTlS/d1c=";
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
