{hostname}: {
  monitor =
    if hostname == "janus"
    then [
      "DP-1, preferred, 1440x900, 1"
      "DP-2, preferred, 0x0, 1, transform, 1"
    ]
    else if hostname == "luna"
    then [
      "eDP-1, 2560x1600@60Hz, 0x0 , 1.6"
      "eDP-2, 2560x1600@60Hz, 0x0 , 1.6"
      "     , preferred     , auto, 1"
    ]
    else [
      ", preferred, auto, 1"
    ];
}
