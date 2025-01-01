{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

    flake-utils.url = "github:numtide/flake-utils";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    jj = {
      url = "github:jj-vcs/jj";
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

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    overlays = [(import ./overlays.nix {inherit pkgs system inputs;})];

    registry = {
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
      make_system = hostname:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs.hostname = hostname;
          modules = [
            lix-module.nixosModules.default
            ./system/common.nix
            ./system/${hostname}.nix
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
      make_home = {
        hostname,
        email,
        gpg-key,
      }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit system hostname email gpg-key;
            inherit (inputs) nix-std;
          };
          modules = [
            ./home/${hostname}.nix
            registry
            inputs.nix-index-database.hmModules.nix-index
            {programs.nix-index-database.comma.enable = true;}
          ];
        };
      make = defaults: names:
        builtins.listToAttrs (map (n: let
            hostname = n.hostname or n;
            username = n.username or defaults.username;
            home-name = n.home-name or "${username}@${hostname}";
            email = n.email or defaults.email;
            gpg-key = n.gpg-key or defaults.gpg-key;
          in {
            name = home-name;
            value = make_home {inherit hostname email gpg-key;};
          })
          names);
    in
      make {
        username = "bryce";
        email = "bryce.z.berger@gmail.com";
        gpg-key = "FDBF801F1CE5FB66EC3075C058CA4F9FEF8F4296";
      } [
        "luna"
        "janus"
        "encaladus"
        {
          hostname = "mimas";
          username = "bryce.berger.local";
          home-name = "bryce.berger.local";
          email = "bryce.z.berger.civ@us.navy.mil";
          gpg-key = "68DF074C1EA2114F91AD98E3F0353FDEC1417AFA";
        }
      ];

    packages.${system}.home-manager = home-manager.packages.${system}.default;
  };
}
