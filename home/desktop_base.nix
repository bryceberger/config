{
  pkgs,
  hostname,
  ...
}: let
  inherit (builtins) filter attrValues;
  inherit (pkgs.lib) isDerivation;

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
          firefox
          zen-browser
          pavucontrol
          playerctl
        ]
        ++ always-packages
        ++ filter isDerivation (attrValues pkgs.nerd-fonts);
    }
    else {
      home.packages = always-packages;
    }
  )
