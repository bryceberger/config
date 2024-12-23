{
  pkgs,
  hostname,
  ...
}: {
  programs.kitty = {
    enable = true;

    package =
      if hostname == "mimas"
      then pkgs.hello
      else pkgs.kitty;

    settings = {
      window_padding_width = 5;
      font_size = 12;
      font_family = "Maple Mono";
      # font_family = "FiraCode Nerd Font";
      # font_features = "FiraCodeNF-Reg +ss08";
    };

    keybindings = {
      "f3" = "launch --cwd=current --type=os-window";
      "f4" = "launch --cwd=current --type=os-window --os-window-class=floatingkitty";
      "ctrl+alt+plus" = "change_font_size current 12.0";
    };

    themeFile = "Catppuccin-Mocha";
  };

  xdg.configFile = {
    "kitty/diff.conf".source = ./kitty/diff.conf;
  };
}
