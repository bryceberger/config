{
  pkgs,
  power-graphing,
  system,
  ...
}: {
  imports = [
    ./common.nix
    ./devel.nix
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./hyprland.nix
    ./kitty.nix
    ./scripts.nix
    ./sway.nix
    ./utils.nix
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

  home.packages = with pkgs; [
    calibre
    eternal-terminal
    libnotify
    mpv
    yt-dlp
    power-graphing.packages.${system}.default
    (writeShellScriptBin "nix_remote" ''
      remote=ssh-ng://janus
      result=result
      target=$1

      store_path=`nix build --eval-store auto --store $remote --json $target | ${jq}/bin/jq -r '.[0].outputs.out'`

      nix copy --from $remote $store_path
      ln -sfn $store_path $result
    '')
    (writeShellScriptBin "hist" ''
      power-graphing $@ && ${inkscape}/bin/inkview /tmp/out.svg 2>/dev/null &
    '')
    (writeShellScriptBin "kbdbacklighttoggle" ''
      bl=${pkgs.brightnessctl}/bin/brightnessctl
      kb=asus::kbd_backlight
      if [ $($bl -d $kb g) -ne 0 ] ; then
        $bl -d $kb s 0
      else
        $bl -d $kb s 1
      fi
    '')
    (writeScriptBin "pw" ''
      #!${fish}/bin/fish

      if test -z $fmt
          set fmt "+%H:%M:%S"
      end

      while true
          set out (p)
          if test "$out" != "$prev"
              date $fmt | tr -d "\n"

              set split (string split " " $out)

              printf " %s %5.2f\n" $split[1] $split[2]
              set prev $out
          end
          sleep 1
      end
    '')
    (writeScriptBin "p" ''
      #!${fish}/bin/fish
      set base "/sys/class/power_supply/BAT0"
      printf "%s %2.2f" (cat $base/status | head -c 1) (math (cat $base/power_now) / 1000000)
    '')
  ];

  services.swayidle.enable = true;

  xdg.configFile = {
    "swayidle/config".text = ''
      timeout 600 'systemctl suspend'
    '';
  };
}
