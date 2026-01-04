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
    git-pkgs
  ];

  programs.git = {
    enable = true;

    # components
    lfs.enable = true;

    signing = {
      key = gpg-key;
      signByDefault = true;
    };

    settings = {
      user.email = email;
      user.name = "Bryce Berger";

      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";
      include.path = "spork";
      advice.detachedHead = false;

      difftool."difft".cmd = "${pkgs.difftastic}/bin/difft --color always $LOCAL $REMOTE | ${pkgs.delta}/bin/delta";
    };
  };
}
