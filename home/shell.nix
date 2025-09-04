{pkgs, ...}: {
  imports = [
    ./shell/fish.nix
  ];

  home.packages = with pkgs; [
    fd
    fend
    fzf
    hyperfine
    lsd
    ouch
    ripgrep
    usage
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # fish integration doesn't work with starship
  programs.mise.enable = true;

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
