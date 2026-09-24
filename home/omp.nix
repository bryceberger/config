{pkgs, ...}: let
  yaml = pkgs.formats.yaml {};

  omp-config = {
    setupVersion = 2;
    startup = {
      quiet = true;
      checkUpdate = false;
    };
    marketplace.autoUpdate = "off";

    theme.dark = "dark-catppuccin";
    symbolPreset = "nerd";
    display = {
      showTokenUsage = true;
      cacheMissMarker = true;
      showTurnTime = true;
    };
    composer = {
      shape = "rail";
      tokenRate = true;
    };

    collab = {
      relayUrl = "wss://ca0639wk27391.nren.navy.mil:7477";
    };

    modelRoles.default = "qwen3.8:27b";
    modelRoles.tiny = "local/lfm2.5-230m";
    inspect_image.mode = "off";
    steeringMode = "all";
    proseOnlyThinking = false;
    task.maxConcurrency = 2;
    task.completionProbe = false;

    bashInterceptor.enabled = true;
    browser.enabled = false;
    web_search.enabled = false;
    dev.autoqa = false;

    lsp.diagnosticsOnEdit = true;
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
