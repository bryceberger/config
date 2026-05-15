default: build

alias a := activate
alias b := build

build host=`hostname`:
    nom build .#{{ host }}
    nvd diff "$XDG_STATE_HOME/nix/profiles/home-manager" result/home
    nvd diff /nix/var/nix/profiles/system result/system

activate host=`hostname`:
    nom build .#{{ host }}
    ./result/home/activate
    sudo ./result/system/activate
