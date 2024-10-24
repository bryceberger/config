{
  pkgs,
  system,
  ...
}: let
  blacklist = [
    # often have to build, don't use
    "mame"
    "mame2000"
    "mame2003"
    "mame2003-plus"
    "mame2010"
    "mame2015"
    "mame2016"

    # fails to build
    "citra"
  ];

  filter = c:
    (c ? libretroCore)
    && (pkgs.lib.meta.availableOn {inherit system;} c)
    && !(builtins.elem c.core blacklist);

  cores = builtins.filter filter (builtins.attrValues pkgs.libretro);
  retroarch = pkgs.retroarch.override {inherit cores;};
in {
  home.packages = [retroarch];
}
