{pkgs, ...}: let
  lua = (import ./nix/utils.nix {inherit pkgs;}).lua;
in {
  programs.wezterm = {
    enable = true;
    package = pkgs.writeShellScriptBin "wezterm" ''
      temp="''${WEZTERM_LOG:-info,window::os::wayland::pointer=off,window::os::wayland::frame=off}"
      WEZTERM_LOG=''$temp ${pkgs.wezterm}/bin/wezterm ''$@
    '';
    extraConfig = let
      config = {
        default_prog = ["fish"];
        enable_tab_bar = false;
        color_scheme = "Catppuccin Mocha";
        font = lua.call "wezterm.font" {
          family = "FiraCode Nerd Font";
          harfbuzz_features = ["clig=1"];
        };
        keys = [
          {
            key = "F3";
            action = lua.name "wezterm.action.SpawnWindow";
          }
        ];
      };
    in ''
      local config = wezterm.config_builder()
      config = ${lua.from config}
      return config
    '';
  };
}
