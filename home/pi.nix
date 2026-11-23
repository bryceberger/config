{pkgs, ...}: let
  json = pkgs.formats.json {};

  extensions-source = pkgs.buildNpmPackage {
    src = ./pi/extensions;
    pname = "pi-extensions";
    version = "0.0.0";
    npmDepsHash = "sha256-3KJGjgYPO8XwIIeDIx27PCTuzTmDZ8qHei5Gd3X/9zk=";
    dontNpmBuild = true;
  };

  settings = {
    packages = [
      "npm:@danielmeneses/pi-llama-swap"
      "npm:@juicesharp/rpiv-ask-user-question"
      "npm:billion-context"
    ];
    quietStartup = true;
    enableInstallTelemetry = false;

    defaultProvider = "llama-swap";
    defaultModel = "qwen3.8:27b-q5";

    tuiMode = "regular";
    theme = "dark-catppuccin";
    steeringMode = "all";
    showCacheMissNotices = true;
  };
in {
  home.packages = [
    pkgs.pi-coding-agent
  ];
  home.file = {
    ".pi/agent/settings.json".source = json.generate "pi-settings.json" settings;
    ".pi/agent/themes/dark-catppuccin.json".source = ./pi/catppuccin.json;
    ".pi/agent/npm/node_modules".source = "${extensions-source}/lib/node_modules/pi-extensions/node_modules";
  };
}
