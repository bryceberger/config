{pkgs, ...}: {
  imports = [
    ./fish/catppuccin.nix
  ];

  xdg.configFile = {
    "fish/conf.d/00-home-manager-vars.fish" = {
      enable = true;
      text = ''
        function s --wraps "rg --json"
          rg --json $argv | delta --tabs 1
        end

        function ri
          set -l short (ghq list 2>/dev/null | fzf); or return 1
          set -l full (ghq list --full-path --exact "$short" 2>/dev/null)
          cd "$full"
        end

        function r
          set -l full (ghq list --full-path --exact "$argv")
          if [ (count $full) -ne 1 ]; return 1; end
          cd "$full"
        end
        complete -c r -f
        complete -c r -a "(ghq list)"

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
      '';
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      export GPG_TTY=$(tty)
    '';

    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "git";
        src = plugin-git.src;
      }
    ];

    shellAbbrs = {
      "la" = "ls -a";
      "ll" = "ls -l";
      "gd" = "git difftool --dir-diff";
      "c" = "cargo";
      "j" = "just";
      "nr" = "nix_remote";
      "ns" = "nix shell";
    };

    shellAliases = {
      "icat" = "kitty +kitten icat";
      "ls" = "lsd";
    };
  };
}
