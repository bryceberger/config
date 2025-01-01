{pkgs, ...}: {
  imports = [
    ./shell/fish.nix
  ];

  home.packages = with pkgs; [
    fzf
    (writeShellScriptBin "ghq" ''
      # ghq assumes $USER == github username
      USER=bryceberger ${pkgs.ghq}/bin/ghq $@
    '')
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

  xdg.configFile."starship.toml".source = ./shell/starship.toml;
}
