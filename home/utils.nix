{pkgs, ...}: {
  home.packages = with pkgs; [
    du-dust
    bat
    (btop.override {rocmSupport = true;})
    (pkgs.writeShellScriptBin "btop-no-gpu" ''
      exec -a $0 ${btop}/bin/btop "$@"
    '')
    killall
    jq
  ];
}
