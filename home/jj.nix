{
  pkgs,
  gpg-key,
  email,
  ...
}: {
  home.packages = with pkgs; [
    jujutsu
    difftastic
    watchman
    gh
  ];

  xdg.configFile."jj/config.toml".source = pkgs.replaceVars ./jj/config.toml {
    inherit email;
    name = "Bryce Berger";
    key = gpg-key;
  };
}
