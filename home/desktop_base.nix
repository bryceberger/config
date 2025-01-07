{
  pkgs,
  hostname,
  ...
}: let
  inherit (builtins) filter attrValues;
  inherit (pkgs.lib) isDerivation;

  # something something infinite recursion if these are imported from pkgs.lib
  option = default: cond: val:
    if cond
    then val
    else default;
  optionals = option [];
  optionalAttrs = option {};

  is-not-mimas = hostname != "mimas";

  all-nerd-fonts = filter isDerivation (attrValues pkgs.nerd-fonts);

  always-packages = with pkgs; [
    dejavu_fonts
    fira-code
    font-awesome
    maple-mono-NF
    zathura
    pavucontrol
  ];

  not-mimas-pkgs = with pkgs; [
    zen-browser
    playerctl
    xdg-utils
  ];

  packages =
    always-packages
    ++ optionals is-not-mimas not-mimas-pkgs
    ++ optionals is-not-mimas all-nerd-fonts;
in
  {
    imports = [./kitty.nix ./wezterm.nix];
    fonts.fontconfig.enable = true;
    home.packages = packages;
  }
  // optionalAttrs is-not-mimas
  {
    xdg.mimeApps.enable = true;
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        autoload
        sponsorblock
        thumbfast
        uosc
      ];
    };
  }
