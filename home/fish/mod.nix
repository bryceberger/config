{pkgs, ...}: {
  setVars = vals:
    pkgs.lib.foldlAttrs
    (acc: name: value: acc + "set -g ${name} ${toString value}\n")
    ""
    vals;
}
