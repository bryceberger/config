{
  config,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./wayland_base.nix
    ./hyprland/waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings =
      {
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      }
      // import ./hyprland/decoration.nix {}
      // import ./hyprland/input.nix {}
      // import ./hyprland/keybinds.nix {inherit pkgs hostname;}
      // import ./hyprland/monitors.nix {inherit hostname;}
      // import ./hyprland/themes/mocha.nix {}
      // import ./hyprland/window_rules.nix {};

    extraConfig = with pkgs; ''
      exec-once = ${writeShellScriptBin "hyprland-autostart" ''
        ${
          (import ./hyprland/waybar.nix {inherit config pkgs;})
          .programs
          .waybar
          .package
        }/bin/waybar &
        ${hyprpaper}/bin/hyprpaper &
        ${swayidle}/bin/swayidle &
      ''}/bin/hyprland-autostart

      bind   = CTRLSHIFT, escape, submap, clear
      submap = clear
      bind   =          , escape, submap, reset
      submap = reset
    '';
  };

  xdg.configFile = let
    wallpaperFile = ./hyprland/wallpapers/blank.png;
  in {
    "hypr/hyprpaper.conf".text = ''
      preload   =   ${wallpaperFile}
      wallpaper = , ${wallpaperFile}
      splash    = false
    '';
  };

  home.packages = with pkgs; [
    hyprpaper
    (writeShellScriptBin "whl" ''
      exec ${pkgs.hyprland}/bin/.Hyprland-wrapped $argv
    '')
    (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | ${wl-clipboard}/bin/wl-copy
    '')
    (writeShellScriptBin "screenshot-window" ''
      set -e
      grim -g "$(hyprctl clients -j | jq -r '.[] | select(.hidden == false) | {pos: .at, size, title} | "\(.pos[0]?),\(.pos[1]?) \(.size[0]?)x\(.size[1]?) \(.title)"' | slurp)" - | wl-copy
    '')
  ];
}
