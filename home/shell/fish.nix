{pkgs, ...}: let
  inherit (pkgs.lib) getExe;
  inherit (pkgs) jj-manage;
  functions = ''
    function s --wraps "rg --json"
      rg --json $argv | delta --tabs 1
    end

    function ri
      set -l short (${getExe jj-manage} list | fzf); or return 1
      set -l base (${getExe jj-manage} base)
      cd "$base/$short"
    end

    function r
      set -l full (${getExe jj-manage} resolve --long $argv || return 1)
      cd "$full"
    end
    complete -c r -f
    complete -c r -a "(${getExe jj-manage} list)"

    function bind_bang
      switch (commandline --current-token)[-1]
        case "!"
          commandline --current-token -- $history[1]
        case "*"
          commandline --insert !
      end
    end
    bind ! bind_bang

    function bind_question
      switch (commandline --current-token)[-1]
        case "\$"
          commandline --current-token -- "\$status"
        case "*"
          commandline --insert \?
      end
    end
    bind \? bind_question

    function tmp
      set -l tmpdir (mktemp -d)
      cd $tmpdir
      fish $argv
      set -l ret $status
      cd $dirprev[-1]
      return $ret
    end
  '';
in {
  imports = [
    ./fish/catppuccin.nix
  ];

  xdg.configFile = {
    "fish/conf.d/00-functions.fish" = {
      enable = true;
      text = functions;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
      export GPG_TTY=$(tty)
    '';

    plugins = let
      plugins = builtins.map (x: {
        name = x;
        src = pkgs.fishPlugins."${x}".src;
      });
    in
      plugins [
        "autopair"
        "plugin-git"
      ];

    shellAbbrs = {
      "la" = "ls -a";
      "ll" = "ls -l";
      "c" = "cargo";
      "j" = "just";
    };

    shellAliases = {
      "icat" = "kitty +kitten icat";
      "ls" = "lsd";
    };
  };
}
