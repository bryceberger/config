default: build

alias a := activate
alias b := build

build host=`hostname`:
    nom build .#{{ host }}
    dix "$XDG_STATE_HOME/nix/profiles/home-manager" result/home
    dix /nix/var/nix/profiles/system result/system

activate host=`hostname`: (build host)
    ./result/home/activate
    sudo ./result/system/activate
