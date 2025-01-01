{pkgs, ...}: {
  home.packages = with pkgs; [
    du-dust
    bat
    # https://github.com/NixOS/nixpkgs/issues/368672
    # (btop.override {rocmSupport = true;})
    # (pkgs.writeShellScriptBin "btop-no-gpu" ''
    #   exec -a $0 ${btop}/bin/btop "$@"
    # '')
    btop
    killall
    jq
  ];
}
