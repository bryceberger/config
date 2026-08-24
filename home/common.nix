{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "hx";
    PAGER = "sp";
    NINJA_STATUS = "[%r/%u/%t] %w (%W) > ";
  };
  home.packages = with pkgs; [
    dix
    nix-output-monitor
    streampager
    xh
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
}
