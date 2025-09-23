{
  pkgs,
  gpg-key,
  email,
  ...
}: {
  imports = [./github.nix];
  home.packages = with pkgs; [
    difftastic
    gitoxide # for gix clean
  ];

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
