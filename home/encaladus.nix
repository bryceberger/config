{...}: {
  imports = [
    ./common.nix
  ];

  home.username = "bryce";
  home.homeDirectory = "/home/bryce";
  home.stateVersion = "24.05";
}
