{pkgs, ...}: {
  home.packages = with pkgs; [
    dust
    bat
    (btop.override {rocmSupport = true;})
    (pkgs.writeShellScriptBin "btop-no-gpu" ''
      exec -a $0 ${btop.override {rocmSupport = false;}}/bin/btop "$@"
    '')
    killall
    jq
  ];
}
