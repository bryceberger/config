{...}: {
  imports = [
    ./common.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./jj.nix
    ./kitty.nix
    ./shell.nix
    ./utils.nix
  ];

  home.username = "bryce";
  home.homeDirectory = "/home/bryce";
  home.stateVersion = "24.05";
}
