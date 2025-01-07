{
  pkgs,
  gpg-key,
  email,
  ...
}: let
  settings = {
    user = {
      name = "Bryce Berger";
      inherit email;
    };
    signing = {
      sign-all = true;
      backend = "gpg";
      key = gpg-key;
    };

    core = {
      fsmonitor = "watchman";
      watchman.register_snapshot_trigger = true;
    };

    git = {
      push-bookmark-prefix = "bryce/push-";
      private-commits = "description(glob:'private:*')";
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
      cur_bookmark = ["log" "-n1" "--no-graph" "-r" "latest(main..@ & bookmarks())" "-T" "if(bookmarks.len() <= 1, bookmarks, '__err_multiple_bookmarks')"];
      dv = ["--config=templates.draft_commit_description=commit_description_verbose" "describe"];
      ds = ["diff" "--stat"];
      k = ["diff" "--tool" "kitty"];
    };

    merge-tools = {
      difft.diff-args = ["--color=always" "$left" "$right"];
      kitty.diff-args = ["+kitten" "diff" "$left" "$right"];
    };
  };
in {
  home.packages = with pkgs; [
    difftastic
    watchman
    gh
  ];

  programs.jujutsu = {
    enable = true;
    inherit settings;
  };
}
