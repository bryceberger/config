{
  pkgs,
  system,
  ...
}: let
  inherit (builtins) filter elem attrValues;
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
    "dolphin"
    "pcsx2"
    "thepowdertoy"
    "tic80"
  ];

  f = c:
    (c ? libretroCore)
    && (pkgs.lib.meta.availableOn {inherit system;} c)
    && !(elem c.core blacklist);
  cores = cs: filter f (attrValues cs);
  retroarch = pkgs.retroarch.withCores cores;
in {
  home.packages = [retroarch];
}
