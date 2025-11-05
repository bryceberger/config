{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./common.nix
    ./devel.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./jj.nix
    ./kitty.nix
    ./retroarch.nix
    ./scripts.nix
    ./shell.nix
    ./sway.nix
    ./utils.nix
    ./xdg.nix
  ];

  home.username = "bryce";
  home.homeDirectory = "/home/bryce";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  xdg.configFile."openxr/1/monado.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
  xdg.configFile."openvr/monado.vrpath".text = let
    steam = "${config.xdg.dataHome}/Steam";
  in
    builtins.toJSON {
      config = ["${steam}/config"];
      external_drivers = null;
      jsonid = "vrpathreg";
      log = ["${steam}/logs"];
      runtime = [
        # "${steam}/steamapps/common/SteamVR"
        "${pkgs.opencomposite}/lib/opencomposite"
      ];
      version = 1;
    };

  home.packages = with pkgs; [
    calibre
    libnotify
    waypipe
    wlx-overlay-s
    bs-manager
    nexusmods-app-unfree
    protontricks
    (pkgs.writeShellScriptBin "set-vr" (builtins.readFile ./janus/set-vr.sh))
  ];
}
