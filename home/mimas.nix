{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./devel.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./jj.nix
    ./shell.nix
    ./sway.nix
    ./utils.nix
    ./xdg.nix
  ];

  home.username = "bryce.berger.local";
  home.homeDirectory = "/home/bryce.berger.local";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    brightnessctl
    patchelf
    glab
    (writeShellScriptBin "cal" ''${util-linux.bin}/bin/cal "$@"'')
  ];

  nix.gc.automatic = true;
  nix.channels = {inherit (inputs) nixpkgs;};
}
