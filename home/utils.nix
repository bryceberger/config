{pkgs, ...}: {
  home.packages = with pkgs; [
    du-dust
    bat
    (btop.override {rocmSupport = true;})
    killall
    jq
  ];
}
