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
    };

    modelRoles.default = "qwen3.8:27b";
    inspect_image.mode = "off";

    bashInterceptor.enabled = true;
  };

  models.providers.janus = {
    baseUrl = "http://janus:9292/v1";
    auth = "none";
    api = "openai-completions";
    omitMaxOutputTokens = true;
    discovery.type = "llama.cpp";
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
    "omp/agent/models.yml".source = yaml.generate "omp-models.yml" models;
  };
}
