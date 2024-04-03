{pkgs, ...}: let
  fish = import ./mod.nix {inherit pkgs;};
in {
  xdg.configFile = {
    "fish/conf.d/00-colors.fish".text = fish.setVars {
      # Catppuccin color palette
      text = "";

      # --> special
      foreground = "cdd6f4";
      selection = "313244";

      # --> palette
      teal = "94e2d5";
      flamingo = "f2cdcd";
      mauve = "cba6f7";
      pink = "f5c2e7";
      red = "f38ba8";
      peach = "fab387";
      green = "a6e3a1";
      yellow = "f9e2af";
      blue = "89b4fa";
      gray = "6c7086";
    };

    "fish/conf.d/01-theme.fish".text = fish.setVars {
      # Syntax Highlighting
      fish_color_normal = "$foreground";
      fish_color_command = "$blue";
      fish_color_param = "$flamingo";
      fish_color_keyword = "$red";
      fish_color_quote = "$green";
      fish_color_redirection = "$pink";
      fish_color_end = "$peach";
      fish_color_error = "$red";
      fish_color_gray = "$gray";
      fish_color_selection = "--background=$selection";
      fish_color_search_match = "--background=$selection";
      fish_color_operator = "$pink";
      fish_color_escape = "$flamingo";
      fish_color_autosuggestion = "$gray";
      fish_color_cancel = "$red";

      # Prompt
      fish_color_cwd = "$yellow";
      fish_color_user = "$teal";
      fish_color_host = "$blue";

      # Completion Pager
      fish_pager_color_progress = "$gray";
      fish_pager_color_prefix = "$pink";
      fish_pager_color_completion = "$foreground";
      fish_pager_color_description = "$gray";
    };
  };
}
