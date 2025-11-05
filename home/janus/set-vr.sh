#!/usr/bin/env bash
set -eu

err() {
    printf "\x1b[31merror\x1b[0m: %s\n" "$@"
    exit 1
}

openxr_target=~/.config/openxr/1/active_runtime.json
openvr_target=~/.config/openvr/openvrpaths.vrpath

case $1 in
steam)
    openxr=~/.config/openxr/1/steam.json
    openvr=~/.config/openvr/steam.vrpath
    ;;
monado)
    openxr=~/.config/openxr/1/monado.json
    openvr=~/.config/openvr/monado.vrpath
    ;;
*)
    err "unsupported target: $1" \
        " supported targets: monado steam"
    ;;
esac

ln -sf "$openxr" "$openxr_target"
ln -sf "$openvr" "$openvr_target"
