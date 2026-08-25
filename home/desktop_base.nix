{
  pkgs,
  lib,
  config,
  hostname,
  ...
}: let
  inherit (builtins) filter attrValues;
  inherit (lib) isDerivation optional optionals optionalAttrs;

  is-not-mimas = hostname != "mimas";

  all-nerd-fonts = filter isDerivation (attrValues pkgs.nerd-fonts);

  always-packages = with pkgs;
    [
      dejavu_fonts
      fira-code
      font-awesome
      fuzzel
      grim
      maple-mono.NF
      pavucontrol
      slurp
      wayland
      wl-clipboard

      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" ~/downloads/screenshot.png
      '')
    ]
    ++ all-nerd-fonts;

  not-mimas-pkgs = with pkgs; [
    playerctl
    swayidle
    xdg-utils

    (writeShellScriptBin "lock" ''
      ${pkgs.swaylock}/bin/swaylock -c 1e1e2eff
    '')
  ];

  packages = always-packages ++ optionals is-not-mimas not-mimas-pkgs;

  cursor-size = 24;
in
  {
    imports = [./kitty.nix] ++ optional is-not-mimas ./firefox.nix;
    fonts.fontconfig.enable = true;
    home.packages = packages;

    programs.zathura = {
      enable = true;
      options.show-recent = 0;
    };

    home.sessionVariables = {
      XCURSOR_SIZE = cursor-size;
      XCURSOR_PATH = "${config.home.homeDirectory}/.local/state/nix/profile/share/icons";
    };

    home.pointerCursor = {
      name = "crosshair-cursor";
      package = pkgs.crosshair-cursor;
      size = cursor-size;
      enable = true;
      x11.enable = true;
      gtk.enable = true;
    };
  }
  // optionalAttrs is-not-mimas {
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

    programs.swaylock = {
      settings.color = "1e1e2eff";
    };
  }
