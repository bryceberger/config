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
      font_size = 10;
      font_family = "Maple Mono NF";
      # "==" and "!=" ligatures
      font_features = "MapleMonoNF-Regular +ss01";
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
