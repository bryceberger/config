{...}: {
  imports = [
    ./shell/fish.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.atuin = {
    enable = true;
    settings. enter_accept = false;
    flags = ["--disable-up-arrow"];
  };
}
