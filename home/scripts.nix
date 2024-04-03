{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellScriptBin "mount_kindle" ''
      mount $1 $2 -o umask=0022,gid=100,uid=1000
    '')
    (writeShellScriptBin "nix-check-cache" ''
      set -e
      paths=$(nix path-info --recursive $1)
      xargs nix path-info --store https://cache.nixos.org/ >/dev/null <<<$paths
    '')
    (writeShellScriptBin "sccache_s" ''
      set -e

      output=$(sccache -s)
      requests=$(<<<$output grep -E "Compile requests +[[:digit:]]" | sed "s/[^0-9]*\(.*\)/\1/")
      executed=$(<<<$output grep -E "Compile requests executed" | sed "s/[^0-9]*\(.*\)/\1/")
      hits=$(<<<$output grep -E "Cache hits +[[:digit:]]" | sed "s/[^0-9]*\(.*\)/\1/")

      printf "Requests: %d / %d\n" $executed $requests
      printf "Hits:     %d / %d\n" $hits $executed
    '')
    (writeShellScriptBin "cpu" ''
      set -e
      cpu_base=/sys/devices/system/cpu

      if [ "$#" -ne 1 ]
      then cat $cpu_base/cpu0/cpufreq/scaling_governor
      else
        available=$(<$cpu_base/cpu0/cpufreq/scaling_available_governors)
        if ! [[ " $available " == *" $1 "* ]]
        then
          echo "'$1' not valid"
          echo "valid: $available"
          exit 1
        fi
        sudo tee $cpu_base/cpu*/cpufreq/scaling_governor <<<$1
      fi

    '')
  ];
}
