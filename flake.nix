{
  inputs = {
    # https://github.com/NixOS/nixpkgs/pull/347222
    nixpkgs.url = "github:matthewpi/nixpkgs/zen-browser";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
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

    power-graphing.url = "github:bryceberger/power-graphing";
    ups-apply.url = "github:bryceberger/ups";
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
        mesa-downgrade
      ];
    };

    # https://github.com/NixOS/nixpkgs/issues/352725
    mesa-downgrade = final: prev: {
      mesa = prev.mesa.overrideAttrs (new: old: {
        version = "24.2.4";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "mesa";
          repo = "mesa";
          rev = "mesa-${new.version}";
          hash = "sha256-pgyvgMHImWO+b4vpCCe4+zOI98XCqcG8NRWpIcImGUk=";
        };
      });
    };

    registry = {
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
      home.packages = [
        home-manager.packages.${system}.default
      ];
    };
  in {
    nixosConfigurations = let
      make_system = name:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs.hostname = name;
          modules = [
            lix-module.nixosModules.default
            ./system/common.nix
            ./system/${name}.nix
          ];
        };
      make = names:
        builtins.listToAttrs (map (name: {
            inherit name;
            value = make_system name;
          })
          names);
    in
      make ["luna" "janus" "encaladus"];

    homeConfigurations = let
      make_home = name:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit system;
            inherit (inputs) nix-std helix power-graphing ups-apply;
            hostname = name;
          };
          modules = [
            ./home/${name}.nix
            registry
            inputs.nix-index-database.hmModules.nix-index
            {programs.nix-index-database.comma.enable = true;}
          ];
        };
      make = names:
        builtins.listToAttrs (map (name: {
            name = "${username}@${name}";
            value = make_home name;
          })
          names);
    in
      make ["luna" "janus" "encaladus"];

    packages.${system}.home-manager = home-manager.packages.${system}.default;
  };
}
