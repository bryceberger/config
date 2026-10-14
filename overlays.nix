final: prev: let
  overrideRust = {
    pkg,
    owner ? "bryceberger",
    repo ? pkg,
    rev,
    hash,
    cargoHash,
    args ? {},
  }: let
    src = final.fetchFromGitHub {inherit owner repo rev hash;};
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = cargoHash;
    };
  in
    prev."${pkg}".overrideAttrs (args // {inherit src cargoDeps;});
in {
  starship = overrideRust {
    pkg = "starship";
    rev = "3214b05e910aba7eaa22c9be8688a3dd421cc7b1";
    hash = "sha256-UvmGFrL5TnBhFzUrdgZOpHi8i3+CDheiyiHUy9Br4gE=";
    cargoHash = "sha256-9FD3lQ8WMrj5bOfR5WvHR0WEMQPAfKZ5ACyVh5EJYfc=";
  };

  crosshair-cursor = final.callPackage ./overlays/crosshair-cursor.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};
  streampager = final.callPackage ./overlays/streampager.nix {};
  ups-apply = final.callPackage ./overlays/ups-apply.nix {};

  # perl: the pinned revision ships its own bsearch() definition, which glibc
  # 2.44 headers turn into a _Generic macro expansion under C23. Removable once
  # languages.toml pins a perl revision that compiles as C23.
  helix = let
    addPatches = oldAttrs: {
      patches = oldAttrs.patches or [] ++ [./overlays/helix/relative-worktrees.patch];
    };
    grammarOverlays = [
      (self: super: {
        perl = super.perl.overrideAttrs (oldAttrs: {
          FLAGS = oldAttrs.FLAGS or [] ++ ["-std=gnu17"];
        });
      })
    ];
  in
    (prev.helix.overrideAttrs addPatches).override {inherit grammarOverlays;};
}
