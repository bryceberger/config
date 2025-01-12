{
  pkgs,
  gpg-key,
  email,
  ...
}: {
  home.packages = with pkgs; [
    difftastic
    gh
    jj-manage
    jujutsu
    watchman
  ];

  xdg.configFile."jj/config.toml".source = pkgs.replaceVars ./jj/config.toml {
    inherit email;
    name = "Bryce Berger";
    key = gpg-key;
  };
}
