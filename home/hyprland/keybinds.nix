{
  pkgs,
  hostname,
}: let
  browser = "${pkgs.zen-browser}/bin/zen";
  backlight = "${pkgs.brightnessctl}/bin/brightnessctl";
  volume = "${pkgs.wireplumber}/bin/wpctl";
  media = "${pkgs.playerctl}/bin/playerctl";
in {
  bind = with pkgs;
    [
      "SUPER         , M     , exit, "
      "SUPER         , Escape, exec, lock"
      "SUPERSHIFT    , S     , exec, ${pkgs.hyprshot}/bin/hyprshot -m region -o ~/downloads/ -f screenshot.png"
      "CTRLSUPERSHIFT, S     , exec, ${pkgs.hyprshot}/bin/hyprshot -m window -o ~/downloads/ -f screenshot.png"
    ]
    # movement
    ++ builtins.concatLists (
      map
      (x: [
        ("CTRL," + x + ",workspace," + x)
        ("CTRLSHIFT," + x + ",movetoworkspace," + x)
      ]) ["1" "2" "3" "4" "5" "6" "7" "8" "9"]
    )
    ++ [
      "CTRL     , Q     , killactive     , "
      "SUPER    , left  , movefocus      , l"
      "SUPER    , right , movefocus      , r"
      "SUPER    , up    , movefocus      , u"
      "SUPER    , down  , movefocus      , d"
      "SUPER    , h     , movefocus      , l"
      "SUPER    , l     , movefocus      , r"
      "SUPER    , k     , movefocus      , u"
      "SUPER    , j     , movefocus      , d"
      "CTRLSHIFT, h     , resizeactive   , -20 0"
      "CTRLSHIFT, l     , resizeactive   , 20 0"
      "CTRLSHIFT, k     , resizeactive   , 0 -20"
      "CTRLSHIFT, j     , resizeactive   , 0 20"
      "         , F2    , movetoworkspace, special"
      "         , F2    , togglespecialworkspace"
      "         , F1    , togglespecialworkspace"
      "ALT      , 0x0060, togglegroup"
      "ALT      , 0xff09, changegroupactive"
      "CTRLSHIFT, space , togglefloating"
      "SUPER    , space , pin"
      "         , F11   , fullscreen"

      # common programs
      "CTRL     , Return, exec, ${kitty}/bin/kitty"
      "CTRLSHIFT, Return, exec, ${kitty}/bin/kitty --class floatingkitty"
      "SUPER    , W     , exec, ${browser}"
      "SUPER    , Z     , exec, ${zathura}/bin/zathura"
      "ALT      , space , exec, ${fuzzel}/bin/fuzzel -f FiraCode"

      # brightness
      "     , XF86MonBrightnessDown, exec, ${backlight} s 10%-"
      "     , XF86MonBrightnessUp  , exec, ${backlight} s 10%+"
    ]
    ++ (
      if hostname == "luna"
      then [
        "     , F7                   , exec, ${backlight} s 10%-"
        "     , F8                   , exec, ${backlight} s 10%+"
        "SUPER, space                , exec, kbdbacklighttoggle"
      ]
      else []
    )
    ++ [
      # audio / media
      # TODO: what package is wpctl in?
      ", XF86AudioRaiseVolume, exec, ${volume} set-volume @DEFAULT_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, ${volume} set-volume @DEFAULT_SINK@ 5%-"
      ", XF86AudioMute       , exec, ${volume} set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioPlay       , exec, ${media} play-pause"
      ", XF86AudioPause      , exec, ${media} play-pause"
      ", XF86AudioNext       , exec, ${media} next"
      ", XF86AudioPrevious   , exec, ${media} previous"
    ];
}
