{...}: {
  services.syncthing = {
    enable = true;

    overrideDevices = true;
    overrideFolders = true;

    settings.devices = {
      luna.id = "EJM54JZ-EOLM7J4-H5W75AH-GVPHI6R-PN77UNL-S23OCJP-ORNDWAC-YHY4VQE";
      janus.id = "27ENVRO-6BTXPM5-26QF6JJ-F53MTBE-72OMDDM-JBV2XN5-MQ66W62-7TV66AT";
    };
    settings.folders = {
      "retroarch saves" = {
        path = "/home/bryce/.config/retroarch/saves";
        devices = ["luna" "janus"];
      };
      "retroarch savestates" = {
        path = "/home/bryce/.config/retroarch/states";
        devices = ["luna" "janus"];
      };
    };
  };
}
