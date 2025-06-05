{
  system,
  inputs,
}: final: prev: let
  make-starship = {
    name ? "starship",
    rev,
    hash,
    cargoHash,
  }:
    prev.starship.overrideAttrs rec {
      pname = name;
      src = prev.fetchFromGitHub {
        owner = "bryceberger";
        repo = "starship";
        inherit rev hash;
      };
      cargoDeps = prev.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = cargoHash;
      };
    };

  starship-jj-shell = make-starship {
    name = "starship-jj-shell";
    rev = "691521ccf174064e7a234d1d6ca6027bb62146c4";
    hash = "sha256-Iilnwpd9FGPTnHoh/UuAPEjuRCeidk4GxHvi8Zus6Ow=";
    cargoHash = "sha256-LXqvaVGuj1x88Lrd8pg7n145i99BCC7v1Vjn98LJof4=";
  };

  starship-jj-lib = make-starship {
    name = "starship-jj-lib";
    rev = "1f55e66ffdc287eceeb4b35bb3bcdfc2fc8b89ed";
    hash = "sha256-XUJLD4Wq8v8U075X/zNkA9kVHpscHj1qxJ0jHdB8eaw=";
    cargoHash = "sha256-7sgRv/3Ts0eHxis5ifCot5YJJOyWTlUL+/CuVXS8jy8=";
  };

  starship-mm = make-starship {
    rev = "f656ead077f0909cd41a1edd6952fb7c0629a1b3";
    hash = "sha256-KFIn3WfyeS4rFDjFaRdEDT6xlCdQ9368tNKR4PUf32M=";
    cargoHash = "sha256-7sgRv/3Ts0eHxis5ifCot5YJJOyWTlUL+/CuVXS8jy8=";
  };

  difft = prev.difftastic.overrideAttrs rec {
    version = "0.64.0";
    src = prev.fetchFromGitHub {
      owner = "bryceberger";
      repo = "difftastic";
      # https://github.com/Wilfred/difftastic/pull/842
      rev = "7f7313e66dce19d064a15f178900df049fc6fa76";
      hash = "sha256-PWcJO9YRaWBCKkd3m6bfzR9Zz8diXOEml6/BCzWSQNA=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-QWwNU4vOA6jWVb9rHJED/VDhwMFPZCKA4Ajad3W1czw=";
    };
  };

  getpackage = package: inputs.${package}.packages.${system}.default;
in {
  helix = getpackage "helix";
  jj-manage = getpackage "jj-manage";
  jujutsu = getpackage "jj";

  starship = starship-mm;
  inherit starship-jj-lib starship-jj-shell;

  difftastic = difft;
}
