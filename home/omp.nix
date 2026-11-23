{pkgs, ...}: let
  yaml = pkgs.formats.yaml {};

  omp-config = {
    setupVersion = 3;
    startup = {
      quiet = true;
      setupWizard = false;
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
    tui.completeScrollback = true;
    composer = {
      shape = "rail";
      tokenRate = true;
    };
    spelling.autocomplete = "smollm";
    title.icons = "boring";

    magicKeywords.enabled = false;

    collab = {
      relayUrl = "wss://ca0639wk27391.nren.navy.mil:7477";
    };

    modelRoles.default = "qwen3.8:27b";
    modelRoles.tiny = "local/lfm2.5-230m";
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

  omp-wrapped = pkgs.symlinkJoin {
    name = "omp";
    buildInputs = [pkgs.makeWrapper];
    paths = [pkgs.omp];
    postBuild = ''
      wrapProgram $out/bin/omp \
        --set PI_CONFIG_DIR .config/omp
    '';
  };
in {
  home.packages = [
    omp-wrapped
  ];
  xdg.configFile = {
    "omp/agent/config.yml".source = yaml.generate "omp-config.yml" omp-config;
  };
}
