{...}: {
  imports = [
    ./shell/fish.nix
    ./shell/starship.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    settings. enter_accept = false;
    flags = ["--disable-up-arrow"];
  };
}
