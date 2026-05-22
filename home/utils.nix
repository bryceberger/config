{pkgs, ...}: let
  btop = pkgs.btop.override {rocmSupport = true;};
  btop-no-gpu = pkgs.writeShellScriptBin "btop-no-gpu" ''
    exec -a $0 ${pkgs.btop.override {rocmSupport = false;}}/bin/btop "$@"
  '';
  mount-user = pkgs.writeShellScriptBin "mount-user" ''
    mount -o umask=0022,gid=$(id -g),uid=$(id -u) "$@"
  '';
in {
  home.packages = with pkgs; [
    bat
    btop
    btop-no-gpu
    dust
    fd
    fend
    hyperfine
    jq
    killall
    mount-user
    ouch
    ripgrep
  ];
}
