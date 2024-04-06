{pkgs, ...}: let
  playerctl_metadata_cmd = "${pkgs.playerctl}/bin/playerctl -a metadata --format '{\"text\": \"{{playerName}}: {{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"mediaplayer\"}' -F";
  cssColor = vals: pkgs.lib.foldlAttrs (acc: name: value: acc + "@define-color ${name} ${toString value};\n") "" vals;

  waybar-hyprland = pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    postPatch = ''
      # use hyprctl to switch workspaces
      sed -i 's|zext_workspace_handle_v1_activate(workspace_handle_);|const std::string command = "${pkgs.hyprland}/bin/hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());|g' src/modules/wlr/workspace_manager.cpp
    '';
  });
in {
  programs.waybar = {
    enable = true;
    package = waybar-hyprland;

    settings = with pkgs; {
      topBar = {
        layer = "top";
        position = "top";

        modules-left = ["hyprland/workspaces"];

        modules-center = ["clock"];

        modules-right = [
          "custom/medialeft"
          "custom/media"
          "custom/mediaright"
          "pulseaudio"
          "temperature"
          "custom/fan"
          "network"
          "battery"
        ];

        battery = {
          states = {
            good = 90;
            warning = 50;
            critical = 25;
          };
          format = "{icon} {capacity}%";
          format-alt = "{time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format = "{ifname}";
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          on-click = "kitty --class floatingkitty --detach nmtui";
        };

        "custom/fan" = {
          exec = ''
            asusctl profile -p \
            | grep -oE '[^ ]+$' \
            | sed 's/\(.*\)/"\1"/'\
            | jq -rc '{ alt: ., tooltip: . }'
          '';
          return-type = "json";
          interval = "once";
          exec-on-event = true;
          on-click = "asusctl profile -n";
          format = "{icon}";
          format-icons = {
            Performance = "";
            Balanced = "";
            Quiet = "";
          };
        };

        "custom/medialeft" = {
          format = "  ";
          return-type = "json";
          max-length = 70;
          exec = playerctl_metadata_cmd;
          on-click = "${playerctl}/bin/playerctl previous";
        };
        "custom/media" = {
          format = "{icon}";
          return-type = "json";
          format-icons = {
            Playing = " ";
            Paused = " ";
          };
          max-length = 70;
          exec = playerctl_metadata_cmd;
          on-click = "${playerctl}/bin/playerctl play-pause";
        };
        "custom/mediaright" = {
          format = " ";
          return-type = "json";
          max-length = 70;
          exec = playerctl_metadata_cmd;
          on-click = "${playerctl}/bin/playerctl next";
        };

        "wlr/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        clock = {
          format = "{:%F    %H:%M}";
          tooltip = false;
          timezone = "America/Indiana/Indianapolis";
        };

        pulseaudio = {
          format = "{icon} {volume:2}%";
          format-muted = " {volume:2}%";
          format-icons = ["" ""];
          scroll-step = 0;
          # TODO: what package is wpctl in?
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = "${pavucontrol}/bin/pavucontrol";
        };

        temperature = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          format = "{temperatureC}°C";
          format-alt = "{temperatureF}°F";
        };
      };
    };

    style = ''
      @import "themes/mocha.css";

      * {
        font-size: 12px;
        font-family: "Fira Code", "Font Awesome 6 Free";
        font-weight: bold;
        border-radius: 2px;
        border: none;
        margin: 0px;
        padding: 0px;
      }

      tooltip {
        background: @crust;
      }

      window#waybar {
        /* background: transparent; */
        background: @base;
        border-bottom: 2px solid @mantle;
      }

      * :hover {
        box-shadow: none;
        text-shadow: none;
        border: none;
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        border-bottom: 2px solid @mantle;
      }

      .modules-left,
      .modules-center {
        background: @base;
      }

      .modules-left {
        padding: 0 5px;
      }

      #clock,
      #custom-medialeft,
      #custom-media,
      #custom-mediaright,
      #pulseaudio,
      #temperature,
      #custom-fan,
      #network
      #battery {
        color: @text;
        margin: 0 6px;
        padding: 0 5px;
        background: @base;
      }

      #network {
        color: @text;
        margin: 0 10px 0 5px;
      }
      #battery {
        color: @text;
        margin: 0 15px 0 5px;
      }

      #clock {
        border: none;
      }

      #workspaces button {
        color: @text;
      }

      #workspaces button.active {
        color: @pink;
      }

      #custom-media {
        margin: 0;
        padding: 0;
        border-left-style: none;
        border-right-style: none;
        border-radius: 0;
      }
      #custom-medialeft {
        padding: 0 5px;
        border-radius: 2px 0 0 2px;
        border-right-style: none;
        margin: 0 0 0 5px;
      }
      #custom-mediaright {
        padding: 0 5px;
        border-radius: 0 2px 2px 0;
        border-left-style: none;
        margin: 0 5px 0 0;
      }

      #battery {
        margin: 0 0 0 5px;
      }

      #battery.warning {
        color: @peach;
      }
      #battery.critical {
        color: @red;
      }
      #battery.charging {
        color: @green;
      }
    '';
  };

  xdg.configFile = {
    "waybar/themes/mocha.css".text = cssColor {
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";

      text = "#cdd6f4";
      subtext0 = "#a6adc8";
      subtext1 = "#bac2de";

      surface0 = "#313244";
      surface1 = "#45475a";
      surface2 = "#585b70";

      overlay0 = "#6c7086";
      overlay1 = "#7f849c";
      overlay2 = "#9399b2";

      blue = "#89b4fa";
      lavender = "#b4befe";
      sapphire = "#74c7ec";
      sky = "#89dceb";
      teal = "#94e2d5";
      green = "#a6e3a1";
      yellow = "#f9e2af";
      peach = "#fab387";
      maroon = "#eba0ac";
      red = "#f38ba8";
      mauve = "#cba6f7";
      pink = "#f5c2e7";
      flamingo = "#f2cdcd";
      rosewater = "#f5e0dc";
    };
  };
}
