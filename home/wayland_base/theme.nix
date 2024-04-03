{pkgs, ...}: let
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        tweaks = ["rimless" "black"];
        variant = "mocha";
      };
    };
    cursorTheme = {
      # name = "Catppuccin-Mocha-Light";
      # package = pkgs.catppuccin-cursors.mochaLight;
      # name = "Vimix-cursors";
      # package = pkgs.vimix-cursor-theme;
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
      size = 12;
    };
  };
in {
  inherit gtk;
  home.file = {
    ".icons/default/index.theme".text = ''
      [Icon Theme]
      Name=Default
      Inherits=${gtk.cursorTheme.name}
    '';
  };
}
