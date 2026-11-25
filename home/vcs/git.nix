{
  pkgs,
  name,
  email,
  ssh-key,
  ...
}: {
  imports = [
    ./github.nix
  ];
  home.packages = with pkgs; [
    difftastic
    gitoxide # for gix clean
  ];

  programs.git = {
    enable = true;

    signing = {
      key = ssh-key;
      format = "ssh";
      signByDefault = true;
    };

    settings = {
      user = {inherit name email;};
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      init.defaultBranch = "main";
      advice.detachedHead = false;
    };

    includes = [{path = "~/.config/git/local";}];
  };
}
