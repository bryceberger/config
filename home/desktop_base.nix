{pkgs, ...}: {
  imports = [
    ./kitty.nix
    ./wezterm.nix
  ];

  fonts.fontconfig.enable = true;

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autoload
      sponsorblock
      thumbfast
      uosc
    ];
  };

  home.packages = with pkgs; [
    fira-code
    nerdfonts
    font-awesome
    dejavu_fonts

    # standalone
    firefox
    zen-browser
    zathura

    # sound
    pavucontrol
    playerctl
  ];
}
