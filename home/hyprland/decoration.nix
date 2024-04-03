{}: {
  decoration = {
    drop_shadow = false;
    blur = {
      enabled = false;
    };
  };

  general = {
    "col.inactive_border" = "$mantle";
    "col.active_border" = "$border";

    border_size = 2;
    gaps_in = 0;
    gaps_out = 0;

    # not really decoration but has to go here otherwise it overrites above
    bindm = [
      "CTRLSHIFT, mouse:272, movewindow"
      "CTRLSHIFT, mouse:273, resizewindow"
    ];
  };

  dwindle = {
    no_gaps_when_only = true;
    special_scale_factor = 0.8;
  };
  master = {
    special_scale_factor = 0.8;
  };

  animations = {
    enabled = true;
    bezier = "overshot,0.13,0.99,0.29,1.1";
    animation = [
      "windows         , 1,  4, overshot, slide"
      "border          , 1, 10, default"
      "fade            , 1, 10, default"
      "workspaces      , 1,  6, default , slide"
      "specialWorkspace, 1,  6, default , fade"
    ];
  };
}
