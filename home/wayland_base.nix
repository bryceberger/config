{pkgs, ...}: let
  cursor-size = 24;
in {
  imports = [
    ./desktop_base.nix
  ];

  home.sessionVariables = {
    XCURSOR_SIZE = cursor-size;
  };

  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = cursor-size;
    x11.enable = true;
    gtk.enable = true;
  };

  home.packages = with pkgs; [
    fuzzel
    grim
    slurp
    swayidle
    wayland
    wl-clipboard

    (writeShellScriptBin "lock" ''
      ${pkgs.swaylock}/bin/swaylock -c 1e1e2eff
    '')
    (writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" ~/downloads/screenshot.png
    '')
  ];

  programs.swaylock = {
    settings = {
      color = "1e1e2eff";
    };
  };
}
