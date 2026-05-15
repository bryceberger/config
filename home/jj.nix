{
  pkgs,
  name,
  email,
  ...
}: let
  settings = {
    user = {inherit name email;};

    ui = {
      default-command = ["--ignore-working-copy" "log"];
      diff-editor = ":builtin";
      diff-formatter = "difft";
      show-cryptographic-signatures = true;
      pager = ":builtin";
    };

    signing = {
      backend = "gpg";
      behavior = "own";
    };

    fsmonitor = {
      backend = "watchman";
      watchman.register-snapshot-trigger = true;
    };

    merge-tools.git-pkgs = {
      program = "git-pkgs";
      diff-args = ["diff-file" "--color=always" "$left" "$right"];
      diff-invocation-mode = "file-by-file";
      edit-args = [];
    };

    aliases = {
      dv = [
        "--config=templates.draft_commit_description=commit_description_verbose(self)"
        "describe"
      ];

      tug = ["bookmark" "advance"];

      manage = ["util" "exec" "--" "jj-manage"];
      man = ["manage"];
    };
  };
in {
  imports = [
    ./git.nix
    ./github.nix
  ];
  home.packages = with pkgs; [
    difftastic
    git-pkgs
    jj-manage
    jujutsu
    watchman
  ];
  xdg.configFile = {
    "jj/config.toml".source = (pkgs.formats.toml {}).generate "jj-config" settings;
    "jj/conf.d" = {
      source = ./jj/conf.d;
      recursive = true;
    };
  };
}
