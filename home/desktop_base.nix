{
  pkgs,
  hostname,
  ...
}: let
  is-not-mimas = hostname != "mimas";

  always-packages = with pkgs; [
    fira-code
    font-awesome
    dejavu_fonts
    zathura
  ];
in
  {
    imports = [./kitty.nix ./wezterm.nix];
    fonts.fontconfig.enable = true;
  }
  // (
    if is-not-mimas
    then {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          autoload
          sponsorblock
          thumbfast
          uosc
        ];
      };
      home.packages = with pkgs;
        [
          nerdfonts
          firefox
          zen-browser
          pavucontrol
          playerctl
        ]
        ++ always-packages;
    }
    else {
      home.packages = always-packages;
    }
  )
