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
    # delta.enable = true;
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
      advice.detachedHead = false;

      difftool."difft" = {
        cmd = "${pkgs.difftastic}/bin/difft --color always $LOCAL $REMOTE | ${pkgs.delta}/bin/delta";
      };
    };
  };
}
