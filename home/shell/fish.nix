{pkgs, ...}: {
  imports = [
    ./fish/catppuccin.nix
  ];

  xdg.configFile = {
    "fish/conf.d/00-functions.fish" = {
      enable = true;
      source = pkgs.replaceVars ./fish/functions.fish {
        jjm = pkgs.lib.getExe pkgs.jj-manage;
        fzf = pkgs.lib.getExe pkgs.fzf;
      };
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
        "nvm"
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
