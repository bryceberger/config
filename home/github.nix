{...}: {
  programs.gh = {
    enable = true;
    settings = {
      aliases = {
        co = "pr checkout";
      };
      git_protocol = "ssh";
    };
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      repoPaths.":owner/:repo" = "~/repos/github/:owner/:repo";
      confirmQuit = true;

      defaults = {
        preview.width = 70;
        layout.prs.lines.width = 11;
      };

      theme.ui = {
        table.showSeparator = true;
      };
    };
  };
}
