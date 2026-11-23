{
  pkgs,
  lib,
  ...
}: let
  json = pkgs.formats.json {};

  extensions-source = pkgs.buildNpmPackage {
    src = ./pi/extensions;
    pname = "pi-extensions";
    version = "0.0.0";
    npmDepsHash = "sha256-bvbqGeYeM7B6q9uGJvjm9kjk+MdadmBgUM1lchehNW4=";
    dontNpmBuild = true;
  };

  settings = {
    packages = let
      deps = (lib.importJSON ./pi/extensions/package.json).dependencies;
    in
      map (x: "npm:${x}") (builtins.attrNames deps);

    quietStartup = true;
    enableInstallTelemetry = false;

    defaultProvider = "llama-swap";
    defaultModel = "qwen3.8:27b-q5";

    tuiMode = "regular";
    theme = "dark-catppuccin";
    steeringMode = "all";
    showCacheMissNotices = true;
    terminal.showTerminalProgress = true;
  };
in {
  home.sessionVariables.PI_OFFLINE = "1";
  home.packages = [
    pkgs.pi-coding-agent
  ];
  home.file = {
    ".pi/agent/settings.json".source = json.generate "pi-settings.json" settings;
    ".pi/agent/themes/dark-catppuccin.json".source = ./pi/catppuccin.json;
    ".pi/agent/npm/node_modules".source = "${extensions-source}/lib/node_modules/pi-extensions/node_modules";
  };
}
