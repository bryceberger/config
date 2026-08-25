{...}: {
  imports = [
    ./common.nix
    ./gpg.nix
    ./helix.nix
    ./kitty.nix
    ./shell.nix
    ./utils.nix
  ];

  home.username = "bryce";
  home.homeDirectory = "/home/bryce";
  home.stateVersion = "24.05";
}
