{pkgs, ...}: {
  imports = [
    ./kitty.nix
    ./wezterm.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})

    # standalone
    firefox
    thunderbird
    zathura
    slack

    # sound
    pavucontrol
    playerctl
  ];
}
