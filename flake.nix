{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

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
  };

  outputs = {
    nixpkgs,
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
      registry = {
        # useful to use "nixpkgs" in a flake and have it specify a revision
        nixpkgs.to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          rev = nixpkgs.rev;
        };
        # useful to do `nix shell np#hello` and get it from the *local* nixpkgs,
        # instead of downloading the same commit again
        np.flake = nixpkgs;
      };
      common_flake = {
        nix = {inherit registry;};
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = [
          home-manager.packages.${system}.default
        ];
      };
    in {
      luna = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {hostname = "luna";};
        modules = [
          common_flake
          ./system/luna.nix
          ./system/common.nix
        ];
      };
      janus = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {hostname = "janus";};
        modules = [
          common_flake
          ./system/janus.nix
          ./system/common.nix
        ];
      };
    };

    homeConfigurations = let
      extraModules = {
        inherit system;
        inherit (inputs) nix-std helix power-graphing;
      };
      nix-index = [
        inputs.nix-index-database.hmModules.nix-index
        {programs.nix-index-database.comma.enable = true;}
      ];
    in {
      "${username}@luna" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = extraModules // {hostname = "luna";};
        modules = [./home/luna.nix] ++ nix-index;
      };
      "${username}@janus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = extraModules // {hostname = "janus";};
        modules = [./home/janus.nix] ++ nix-index;
      };
    };

    devShells.${system}.default =
      pkgs.mkShell.override {
        stdenv = pkgs.stdenvNoCC;
      } {
        packages = with pkgs; [
          just
        ];
      };
  };
}
