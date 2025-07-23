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
      font_size =
        if hostname == "luna"
        then 10
        else 12;
      font_family = "Maple Mono NF";
    };

    # yes "==" and "!=" ligatures
    # no "<=" and ">=" ligatures
    extraConfig = ''
      font_features MapleMono-NF-Regular -ss01 +ss02
      font_features MapleMono-NF-Italic -ss01 +ss02
      font_features MapleMono-NF-SemiBold -ss01 +ss02
      font_features MapleMono-NF-SemiBoldItalic -ss01 +ss02
    '';

    keybindings = {
      "f3" = "launch --cwd=current --type=os-window";
      "f4" = "launch --cwd=current --type=os-window --os-window-class=floatingkitty";
      "ctrl+alt+plus" = "change_font_size current 12.0";
      "ctrl+shift+p>c" = "kitten hints --program - --type regex --regex [zyxwvutsrqponmlk]{8,32}";
    };

    themeFile = "Catppuccin-Mocha";
  };

  xdg.configFile = {
    "kitty/diff.conf".source = ./kitty/diff.conf;
  };
}
