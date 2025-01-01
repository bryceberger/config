{...}: {
  imports = [
    ./common.nix
    ./shell.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./kitty.nix
    ./utils.nix
  ];

  home.username = "bryce";
  home.homeDirectory = "/home/bryce";
  home.stateVersion = "24.05";
}
