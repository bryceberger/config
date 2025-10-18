{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # look into un-colocating jj repos when merged:
    # https://github.com/helix-editor/helix/pull/12022
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";

    jj.url = "github:bryceberger/jj/mm";
    jj.inputs.nixpkgs.follows = "nixpkgs";
    jj.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    nixpkgs,
    determinate,
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
      nix.registry.nixpkgs.flake = nixpkgs;
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
            determinate.nixosModules.default
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
        username,
        hostname,
        email,
        gpg-key,
      }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs system username hostname email gpg-key;
          };
          modules = [
            ./home/${hostname}.nix
            registry
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
            value = make_home {inherit username hostname email gpg-key;};
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
          gpg-key = "68DF074C1EA2114F91AD98E3F0353FDEC1417AFA";
        }
      ];

    inherit pkgs;
    packages.${system}.home-manager = home-manager.packages.${system}.default;
  };
}
