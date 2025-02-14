{pkgs, ...}: {
  imports = [
    ./shell/fish.nix
  ];

  home.packages = with pkgs; [
    fzf
    ouch
    lsd
    ripgrep
    fend
    fd
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

  xdg.configFile."starship.toml".source = ./shell/starship.toml;
}
