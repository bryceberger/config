{pkgs, ...}: {
  imports = [
    ./desktop_base.nix
  ];

  home.packages = with pkgs; [
    fuzzel
    grim
    slurp
    swayidle
    wayland
    wl-clipboard

    (writeShellScriptBin "lock" ''
      ${pkgs.swaylock}/bin/swaylock -c 1e1e2eff
    '')
    (writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" ~/downloads/screenshot.png
    '')
  ];

  programs.swaylock = {
    settings = {
      color = "1e1e2eff";
    };
  };
}
