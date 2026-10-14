{pkgs, ...}: let
  font = "Maple Mono NF";
  settings = {
    auto_update = false;
    desktop_integration = false;

    theme = "Dark";

    prompt_style = "tern";
    prompt_parts = {
      fill = "text";
      dir = "repo";
      spaced = true;
      collapse = false;
    };

    cursor = {
      shape = "bar";
      programs = true;
    };

    font_family = font;
    font_family_bold = font;
    font_family_bold_italic = font;
    ui_font = font;
    code_font = font;

    material = "Solid";

    command_lenses = false;

    expand_thoughts = true;
    surface_chat = "Console";
    composer_text = "Markdown";
    carly.model = "qwen3.8";

    surface_diffs = "Split";
    git.auto_fetch_minutes = 0;

    keybinds = {
      "ctrl+shift+y" = "switch_host";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
    };
  };
in {
  home.packages = with pkgs; [
    tern
  ];
  xdg.configFile = {
    "tern/settings.json".source = (pkgs.formats.json {}).generate "tern-settings.json" settings;
  };
}
