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

    # my patches + dynamic completions
    # when merged (0.24?) remove line in fish.nix as well
    jj = {
      url = "github:bryceberger/jj/fileset-alias";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    power-graphing = {
      url = "github:bryceberger/power-graphing";
      inputs.utils.follows = "flake-utils";
    };
    ups-apply = {
      url = "github:bryceberger/ups";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    nixpkgs,
    lix-module,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    nixpkgs-config = {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs = hostname: import nixpkgs (nixpkgs-config // {overlays = overlays hostname;});

    overlays = hostname:
      [
        (final: prev: {
          jujutsu = inputs.jj.packages.${system}.jujutsu;
        })
      ]
      ++ (
        if hostname == "janus"
        then [mesa-downgrade]
        else []
      );

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
          inherit system;
          pkgs = pkgs hostname;
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
          pkgs = pkgs hostname;
          extraSpecialArgs = {
            inherit system hostname email gpg-key;
            inherit (inputs) nix-std helix power-graphing ups-apply;
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
