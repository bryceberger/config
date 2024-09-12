{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-std.url = "github:chessai/nix-std";
    flake-utils.url = "github:numtide/flake-utils";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix/snippet_placeholder";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    extest = {
      url = "github:chaorace/extest-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    power-graphing = {
      url = "github:bryceberger/power-graphing";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    ups-apply = {
      url = "github:bryceberger/ups";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    nixpkgs,
    lix-module,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "bryce";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.extest.overlays.default
      ];
    };
  in {
    nixosConfigurations = let
      common_flake = {
        # useful to use "nixpkgs" in a flake and have it specify a revision
        nix.registry.nixpkgs.to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          rev = nixpkgs.rev;
        };
        # useful to do `nix shell np#hello` and get it from the *local* nixpkgs,
        # instead of downloading the same commit again
        nix.registry.np.flake = nixpkgs;
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = [
          home-manager.packages.${system}.default
        ];
      };

      make = names:
        builtins.listToAttrs (map (name: {
            inherit name;
            value = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {hostname = name;};
              modules = [
                common_flake
                lix-module.nixosModules.default
                ./system/common.nix
                ./system/${name}.nix
              ];
            };
          })
          names);
    in
      make ["luna" "janus"];

    homeConfigurations = let
      make = names:
        builtins.listToAttrs (map (name: {
            name = "${username}@${name}";
            value = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit system;
                inherit (inputs) nix-std helix power-graphing ups-apply;
                hostname = name;
              };
              modules = [
                ./home/${name}.nix
                inputs.nix-index-database.hmModules.nix-index
                {programs.nix-index-database.comma.enable = true;}
              ];
            };
          })
          names);
    in
      make ["luna" "janus"];

    devShells.${system}.default =
      pkgs.mkShell.override {
        stdenv = pkgs.stdenvNoCC;
      } {
        packages = [pkgs.just];
      };
  };
}
