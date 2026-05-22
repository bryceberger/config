{
  pkgs,
  name,
  email,
  gpg-key,
  ...
}: {
  imports = [
    ./github.nix
  ];
  home.packages = with pkgs; [
    difftastic
    gitoxide # for gix clean
    git-pkgs
  ];

  programs.git = {
    enable = true;

    signing = {
      key = gpg-key;
      format = "openpgp";
      signByDefault = true;
    };

    settings = {
      user = {inherit name email;};
      init.defaultBranch = "main";
      advice.detachedHead = false;
    };

    includes = [{path = "~/.config/git/local";}];
  };
}
