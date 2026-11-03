final: prev: {
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
