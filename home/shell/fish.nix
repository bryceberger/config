{pkgs, ...}: {
  imports = [
    ./fish/catppuccin.nix
  ];

  home.packages = with pkgs; [
    jj-manage
    fzf
  ];
  xdg.configFile = {
    "fish/conf.d" = {
      source = ./fish/conf.d;
      recursive = true;
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
        "nvm"
      ];

    functions = {
      last_history_item = "echo $history[1]";
      s = {
        wraps = "rg --json";
        body = "rg --json $argv | delta --tabs 1";
      };
      tmp = ''
        set -l tmpdir (mktemp -d)
        cd $tmpdir
        fish $argv
        set -l ret $status
        cd $dirprev[-1]
        return $ret
      '';
    };

    shellAbbrs = {
      "la" = "ls -a";
      "ll" = "ls -l";
      "c" = "cargo";
      "j" = "just";
      "!!" = {
        position = "anywhere";
        function = "last_history_item";
      };
    };

    shellAliases = {
      "icat" = "kitty +kitten icat";
      "ls" = "lsd";
    };
  };
}
