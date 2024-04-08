{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "hx";
  };
  home.packages = with pkgs; [
    nix-output-monitor
  ];
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
