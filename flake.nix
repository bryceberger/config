{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # look into un-colocating jj repos when merged:
    # https://github.com/helix-editor/helix/pull/12022
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    helix.inputs.rust-overlay.follows = "rust-overlay";

    jj.url = "github:jj-vcs/jj/bryce/available-width";
    jj.inputs.nixpkgs.follows = "nixpkgs";
    jj.inputs.flake-utils.follows = "flake-utils";
    jj.inputs.rust-overlay.follows = "rust-overlay";

    oyui.url = "github:emilien-jegou/oyui";
    oyui.inputs.nixpkgs.follows = "nixpkgs";
    oyui.inputs.flake-utils.follows = "flake-utils";
    oyui.inputs.rust-overlay.follows = "rust-overlay";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
      config.rocmSupport = true;
    };

    overlays = [
      (import ./overlays.nix {inherit system inputs;})
      inputs.nur.overlays.default
    ];

    registry = {
      # useful to do `nix shell np#hello` and get it from the *local* nixpkgs,
      # instead of downloading the same commit again
      nix.registry.np.flake = nixpkgs;
      nixpkgs.config.allowUnfree = true;
      home.packages = [
        home-manager.packages.${system}.default
      ];
    };
    nixosConfigurations = let
      make_system = hostname:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs.hostname = hostname;
          modules = [
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
      make_home = args:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = args // {inherit inputs system;};
          modules = [
            ./home/${args.hostname}.nix
            registry
          ];
        };
      make = defaults: names:
        builtins.listToAttrs (map (n: let
            args.name = n.name or defaults.name;
            args.hostname = n.hostname or n;
            args.username = n.username or defaults.username;
            args.email = n.email or defaults.email;
            args.gpg-key = n.gpg-key or defaults.gpg-key;
          in {
            name = n.home-name or "${args.username}@${args.hostname}";
            value = make_home args;
          })
          names);
    in
      make {
        name = "Bryce Berger";
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
          gpg-key = "68DF074C1EA2114F91AD98E3F0353FDEC1417AFA";
        }
      ];

    both = user: host:
      pkgs.linkFarm "both" {
        system = nixosConfigurations.${host}.config.system.build.toplevel;
        home = homeConfigurations."${user}@${host}".config.home.activationPackage;
      };
  in {
    inherit pkgs nixosConfigurations homeConfigurations;
    packages.${system}.home-manager = home-manager.packages.${system}.default;
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        just
      ];
    };

    luna = both "bryce" "luna";
    janus = both "bryce" "janus";
    encaladus = both "bryce" "encaladus";
  };
}
