{
  pkgs,
  gpg-key,
  email,
  ...
}: {
  imports = [./github.nix];
  home.packages = with pkgs; [
    difftastic
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
