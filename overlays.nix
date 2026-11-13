final: prev: {
  crosshair-cursor = final.callPackage ./overlays/crosshair-cursor.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};
  streampager = final.callPackage ./overlays/streampager.nix {};
  ups-apply = final.callPackage ./overlays/ups-apply.nix {};

  # https://github.com/helix-editor/helix/issues/16431#issuecomment-6543022913
  helix = let
    addPatches = oldAttrs: {
      patches = oldAttrs.patches or [] ++ [./overlays/helix/relative-worktrees.patch];
    };
    grammarOverlays = [
      (_final: previous: {
        perl = previous.perl.overrideAttrs (_old: {
          version = "aa5600c8df1eb9ed111db72e20c741dd73ec336a";
          src = fetchTree {
            type = "github";
            owner = "tree-sitter-perl";
            repo = "tree-sitter-perl";
            rev = "aa5600c8df1eb9ed111db72e20c741dd73ec336a";
          };
        });
      })
    ];
  in
    (prev.helix.overrideAttrs addPatches).override {inherit grammarOverlays;};
}
