final: prev: {
  crosshair-cursor = final.callPackage ./overlays/crosshair-cursor.nix {};
  jj-manage = final.callPackage ./overlays/jj-manage.nix {};
  streampager = final.callPackage ./overlays/streampager.nix {};
  tern = final.callPackage ./overlays/tern.nix {};
  ups-apply = final.callPackage ./overlays/ups-apply.nix {};

  # perl: the pinned revision ships its own bsearch() definition, which glibc
  # 2.44 headers turn into a _Generic macro expansion under C23. Removable once
  # languages.toml pins a perl revision that compiles as C23.
  helix = prev.helix.override {
    grammarOverlays = [
      (self: super: {
        perl = super.perl.overrideAttrs (old: {
          FLAGS = old.FLAGS ++ ["-std=gnu17"];
        });
      })
    ];
  };
}
