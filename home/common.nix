{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "hx";
    PAGER = "less -FRX";
    NINJA_STATUS = "[%r/%u/%t] %w (%W) > ";
  };
  home.packages = with pkgs; [
    nix-output-monitor
    nvd
  ];
  programs.nh.enable = true;
  xdg.configFile = {
    "user-dirs.conf" = {
      enable = true;
      text = ''
        enabled=false
      '';
    };
    "user-dirs.dirs" = {
      enable = true;
      text = ''
        XDG_DOWNLOAD_DIR="$HOME/downloads"
        XDG_DOCUMENTS_DIR="$HOME/documents"
      '';
    };
  };
  nix = {
    package = pkgs.lix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
