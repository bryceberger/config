{
  pkgs,
  email,
  ...
}: {
  imports = [./github.nix];
  home.packages = with pkgs; [
    difftastic
    git-pkgs
    jj-manage
    jujutsu
    watchman
  ];

  xdg.configFile."jj/config.toml".source = pkgs.replaceVars ./jj/config.toml {
    inherit email;
    name = "Bryce Berger";
    rdiff = ./jj/rdiff.sh;
  };
}
