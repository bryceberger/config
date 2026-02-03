{
  pkgs,
  hostname,
  ...
}: let
  inherit (pkgs.lib) getExe getExe';
  inherit (pkgs.lib.attrsets) optionalAttrs;

  # weird semi-nix managed system
  exes =
    if hostname == "mimas"
    then {
      browser = "firefox";
      terminal = "~/.local/bin/kitty";
    }
    else {
      browser = getExe pkgs.firefox;
      terminal = getExe pkgs.kitty;
    };

  backlight = getExe pkgs.brightnessctl;
  browser = exes.browser;
  media = getExe pkgs.playerctl;
  menu = getExe pkgs.fuzzel;
  pdf-viewer = getExe pkgs.zathura;
  terminal = exes.terminal;
  volume = getExe' pkgs.wireplumber "wpctl";

  resize_step = "20px";

  super = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";

  outputs = {
    janus = {
      DP-2.pos = "0 0";
      DP-2.transform = "270";
      DP-1.pos = "1440 900";
      HDMI-A-1.disable = "";
    };
    luna = {
      eDP-2.mode = "2560x1600@60Hz";
      eDP-2.scale = "1.6";
    };
  };

  keybindings = {
    "${super}+${left}" = "focus left";
    "${super}+${down}" = "focus down";
    "${super}+${up}" = "focus up";
    "${super}+${right}" = "focus right";
    "${super}+Alt+${left}" = "move left";
    "${super}+Alt+${down}" = "move down";
    "${super}+Alt+${up}" = "move up";
    "${super}+Alt+${right}" = "move right";
    "Control+Shift+${left}" = "resize shrink width " + resize_step;
    "Control+Shift+${down}" = "resize grow height " + resize_step;
    "Control+Shift+${up}" = "resize shrink height " + resize_step;
    "Control+Shift+${right}" = "resize grow width " + resize_step;

    "${super}+Escape" = "exec lock";
    "${super}+Shift+s" = "exec screenshot";

    "Control+q" = "kill";

    "Control+Return" = "exec ${terminal}";
    "Control+Shift+Return" = "exec ${terminal} --class floating_term";
    "${super}+w" = "exec ${browser}";
    "${super}+z" = "exec ${pdf-viewer}";
    "Alt+space" = "exec ${menu}";

    "Control+Shift+space" = "floating toggle";

    "F11" = "fullscreen";

    "F1" = "scratchpad show";
    "Control+F1" = "resize set width 80ppt height 80ppt; move position center";
    "F2" = "move scratchpad";

    "XF86AudioRaiseVolume" = "exec ${volume} set-volume @DEFAULT_SINK@ 5%+";
    "XF86AudioLowerVolume" = "exec ${volume} set-volume @DEFAULT_SINK@ 5%-";
    "XF86AudioMute" = "exec ${volume} set-sink-mute @DEFAULT_SINK@ toggle";
    "XF86AudioPlay" = "exec ${media} play-pause";
    "XF86AudioPause" = "exec ${media} play-pause";
    "XF86AudioNext" = "exec ${media} next";
    "XF86AudioPrev" = "exec ${media} previous";

    "XF86MonBrightnessDown" = "exec ${backlight} s 10%-";
    "XF86MonBrightnessUp" = "exec ${backlight} s 10%+";
  };

  workspace-keybinds = let
    make-workspace-keybind = x: [
      {
        "Control+${x}" = "workspace ${x}";
        "Control+Shift+${x}" = "move container to workspace " + x;
        "Control+Alt+${x}" = "move container to workspace " + x;
      }
    ];
    workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
  in
    pkgs.lib.attrsets.mergeAttrsList (
      builtins.concatLists (map make-workspace-keybind workspaces)
    );
in {
  imports = [
    ./wayland_base.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = {
      window.titlebar = false;

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_options = "ctrl:nocaps";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      output = outputs.${hostname} or {};

      bars = [
        {
          position =
            if hostname == "janus"
            then "bottom"
            else "top";
          statusCommand = getExe pkgs.i3status;
          fonts = {
            names = ["Maple Mono NF"];
            size = 8.0;
          };
        }
      ];

      floating.modifier = super;

      keybindings =
        keybindings
        // workspace-keybinds
        // optionalAttrs (hostname == "luna") {
          "${super}+space" = "exec kbdbacklighttoggle";
        };
    };
  };
}
