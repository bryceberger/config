{pkgs, ...}: let
  cores = c: [
    c.mgba
    c.snes9x
  ];
in {
  home.packages = [
    (pkgs.retroarch.withCores cores)
    pkgs.ups-apply
    pkgs.dolphin-emu
  ];
}
