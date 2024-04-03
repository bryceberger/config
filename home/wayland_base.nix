{pkgs, ...}: {
  imports = [
    ./wayland_base/theme.nix
    ./desktop_base.nix
  ];

  home.packages = with pkgs; [
    fuzzel
    grim
    slurp
    swayidle
    wayland
    wl-clipboard
    swaynotificationcenter

    (writeShellScriptBin "lock" ''
      ${pkgs.swaylock}/bin/swaylock -c 1e1e2eff
    '')
  ];

  programs.swaylock = {
    settings = {
      color = "000000";
    };
  };
}
