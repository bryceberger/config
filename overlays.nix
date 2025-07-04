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
      rev = "5d1e518212fc3e0d6fc2c1e261b1c800e5032773";
      hash = "sha256-wOXr/u2ZzLVNT8zjjLUjcf3Dt1HSzX2LUi9by5okIIQ=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-wMRRZq9+g8rGJD1kHcL3OdBTTsbGxysbYFQTzhtlbRM=";
    };
  };

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jj-manage = getpackage "jj-manage";
  jujutsu = getpackage "jj";
  inherit starship difftastic;
}
