{
  pkgs,
  hostname,
  ...
}: let
  # weird semi-nix managed system
  exes =
    if hostname == "mimas"
    then {
      browser = "/bin/firefox";
      terminal = "/bin/kitty";
      menu = "rofi -show run";
    }
    else {
      browser = "${pkgs.zen-browser}/bin/zen";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
    };
  inherit (exes) browser terminal menu;
  pdf-viewer = "${pkgs.zathura}/bin/zathura";

  volume = "${pkgs.wireplumber}/bin/wpctl";
  media = "${pkgs.playerctl}/bin/playerctl";

  resize_step = "20px";

  super = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
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

      output =
        if hostname == "janus"
        then {
          "DP-2" = {
            pos = "0 0";
            transform = "270";
          };
          "DP-1" = {pos = "1440 900";};
          "HDMI-A-1" = {disable = "";};
        }
        else if hostname == "luna"
        then let
          args = {
            mode = "2560x1600@60Hz";
            scale = "1.6";
          };
        in {
          "eDP-1" = args;
          "eDP-2" = args;
        }
        else {};

      bars = [
        {
          position =
            if hostname == "janus"
            then "bottom"
            else "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = {
            names = ["Maple Mono NF"];
            size = 8.0;
          };
        }
      ];

      floating.modifier = super;

      keybindings =
        {
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
          "${super}+f" = "fullscreen";

          "F2" = "move scratchpad";
          "F1" = "scratchpad show";

          "XF86AudioRaiseVolume" = "exec ${volume} set-volume @DEFAULT_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${volume} set-volume @DEFAULT_SINK@ 5%-";
          "XF86AudioMute" = "exec ${volume} set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioPlay" = "exec ${media} play-pause";
          "XF86AudioPause" = "exec ${media} play-pause";
          "XF86AudioNext" = "exec ${media} next";
          "XF86AudioPrev" = "exec ${media} previous";
        }
        // builtins.listToAttrs (builtins.concatLists (map
          (
            x: [
              {
                name = "Control+" + x;
                value = "workspace " + x;
              }
              {
                name = "Control+Shift+" + x;
                value = "move container to workspace " + x;
              }
              {
                name = "Control+Alt+" + x;
                value = "move container to workspace " + x;
              }
            ]
          ) ["1" "2" "3" "4" "5" "6" "7" "8" "9"]));
    };
  };
}
