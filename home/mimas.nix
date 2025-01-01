{pkgs, ...}: {
  imports = [
    ./common.nix
    ./devel.nix
    ./shell.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./sway.nix
    ./utils.nix
  ];

  home.username = "bryce.berger.local";
  home.homeDirectory = "/home/bryce.berger.local";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    brightnessctl
    patchelf
  ];
}
