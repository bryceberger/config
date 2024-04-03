{pkgs, ...}: let
  browser = "${pkgs.firefox}/bin/firefox";
  resize_step = "20px";
  super = "Mod4";
in {
  imports = [
    ./wayland_base.nix
  ];

  home.packages = with pkgs; [
    sway
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      modifier = "Control";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";

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

      # floating.modifier = modifier + "+Shift";

      left = "h";
      down = "j";
      up = "k";
      right = "l";

      keybindings =
        {
          "${modifier}+Shift+${left}" = "focus left";
          "${modifier}+Shift+${down}" = "focus down";
          "${modifier}+Shift+${up}" = "focus up";
          "${modifier}+Shift+${right}" = "focus right";
          "${modifier}+Alt+${left}" = "move left";
          "${modifier}+Alt+${down}" = "move down";
          "${modifier}+Alt+${up}" = "move up";
          "${modifier}+Alt+${right}" = "move right";
          "${modifier}+${super}+${left}" = "resize shrink width " + resize_step;
          "${modifier}+${super}+${down}" = "resize grow height " + resize_step;
          "${modifier}+${super}+${up}" = "resize shrink height " + resize_step;
          "${modifier}+${super}+${right}" = "resize grow width " + resize_step;

          "${modifier}+q" = "kill";

          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+Return" = "exec ${terminal} --class floating_term";
          "${super}+w" = "exec ${browser}";
          "Alt+space" = "exec ${menu}";

          "${modifier}+Shift+space" = "floating toggle";

          "F2" = "move scratchpad";
          "F1" = "scratchpad show";
        }
        // builtins.listToAttrs (builtins.concatLists (map
          (
            x: [
              {
                name = "${modifier}+" + x;
                value = "workspace " + x;
              }
              {
                name = "${modifier}+Shift+" + x;
                value = "move container to workspace " + x;
              }
            ]
          ) ["1" "2" "3" "4" "5" "6" "7" "8" "9"]));
    };
  };
}
