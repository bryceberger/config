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

  home.sessionVariables = let
    cursor_size = 24;
  in {
    HYPRCURSOR_SIZE = cursor_size;
    XCURSOR_SIZE = cursor_size;
  };

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
      exec-once = hyprctl setcursor ${config.gtk.cursorTheme.name} 24

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

  home.packages = with pkgs;
    [
      hyprpaper
      hyprcursor
      (writeShellScriptBin "whl" ''
        exec ${hyprland}/bin/.Hyprland-wrapped $argv
      '')
      (writeShellScriptBin "screenshot" ''
        ${hyprshot}/bin/hyprshot -m region -o ~/downloads/ -f screenshot.png
      '')
      (writeShellScriptBin "screenshot-window" ''
        ${hyprshot}/bin/hyprshot -m window -o ~/downloads/ -f screenshot.png
      '')
    ]
    ++ (
      if hostname == "janus"
      then [
        (pkgs.writeShellScriptBin "tv_off" "hyprctl keyword monitor HDMI-A-1,disable")
        (pkgs.writeShellScriptBin "tv_on" "hyprctl keyword monitor HDMI-A-1,4096x2160@60Hz,auto,1")
      ]
      else []
    );
}
