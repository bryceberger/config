{pkgs, ...}: let
  yaml = pkgs.formats.yaml {};

  omp-config = {
    setupVersion = 2;
    startup.quiet = true;
    theme.dark = "dark-catppuccin";
    symbolPreset = "nerd";
    statusLine.contextLine = "percentage";
    display = {
      showTokenUsage = true;
      cacheMissMarker = true;
      showTurnTime = true;
    };

    modelRoles.default = "qwen3.8:27b";
    inspect_image.mode = "off";

    bashInterceptor.enabled = true;
  };
in {
  home.packages = with pkgs; [
    omp
  ];
  home.sessionVariables = {
    PI_CONFIG_DIR = ".config/omp";
  };
  xdg.configFile = {
    "omp/agent/config.yml".source = yaml.generate "omp-config.yml" omp-config;
  };
}
