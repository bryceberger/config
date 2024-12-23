{
  pkgs,
  nix-std,
  gpg-key,
  email,
  ...
}: let
  std = nix-std.lib;
in {
  home.packages = with pkgs; [
    difftastic
  ];
  programs.jujutsu = {
    enable = true;
  };
  xdg.configFile."jj/config.toml".text = std.serde.toTOML {
    user = {
      name = "Bryce Berger";
      inherit email;
    };
    ui = {
      diff-editor = ":builtin";
      default-command = [
        "log"
        "-T"
        ''separate(" ", change_id.shortest(8), commit_id.shortest(8), working_copies, bookmarks, description.first_line())''
      ];
    };

    template-aliases = {
      commit_description_verbose = ''
        concat(
          description,
          "\n",
          "JJ: This commit contains the following changes:\n",
          indent("JJ:    ", diff.stat(72)),
          "JJ: ignore-rest\n",
          diff.git(),
        )
      '';
    };
    templates = {
      draft_commit_description = ''
        concat(
          description,
          "\n",
          "JJ: This commit contains the following changes:\n",
          indent("JJ:    ", diff.stat(72)),
        )
      '';
    };

    aliases = {
      tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
      dv = ["--config=templates.draft_commit_description=commit_description_verbose" "describe"];
    };

    merge-tools = {
      difft.diff-args = ["--color=always" "$left" "$right"];
      kitty.diff-args = ["+kitten" "diff" "$left" "$right"];
    };
    signing = {
      sign-all = true;
      backend = "gpg";
      key = gpg-key;
    };
    git.private-commits = "description(glob:'private:*')";
  };

  programs.git = {
    enable = true;

    # components
    delta.enable = true;
    lfs.enable = true;

    # user
    userEmail = email;
    userName = "Bryce Berger";
    signing = {
      key = gpg-key;
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";
      include.path = "spork";

      diff = {
        tool = "kitty";
      };
      difftool."kitty" = {
        cmd = "kitty +kitten diff $LOCAL $REMOTE";
      };
      difftool."difft" = {
        cmd = "${pkgs.difftastic}/bin/difft --color always $LOCAL $REMOTE | ${pkgs.delta}/bin/delta";
      };

      delta = {
        navigate = true;
        syntax-theme = "Catppuccin-mocha";
        side-by-side = true;
        features = "custom-theme";

        custom-theme = {
          minus-style = "syntax '#5E3F53'";
          minus-non-emph-style = "syntax '#5E3F53'";
          minus-emph-style = "syntax '#89556B'";
          minus-empty-line-marker-style = "normal '#734A5F'";

          plus-style = "syntax '#475951'";
          plus-non-emph-style = "syntax '#475951'";
          plus-emph-style = "syntax '#628168'";
          plus-empty-line-marker-styl = "normal '#628168'";

          map-styles = "bold purple => syntax '#4D4365', bold cyan => syntax '#3B4766'";

          blame-palette = "#11111b #1e1e2e #313244";

          file-style = "bright-yellow";
          hunk-header-style = "bold syntax";

          line-numbers = "true";
        };
      };
    };
  };
}
