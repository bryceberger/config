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
}
