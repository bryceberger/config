default: build

alias a := activate
alias b := build

build host=`hostname`:
    rom build .#{{ host }}
    dix diff "$XDG_STATE_HOME/nix/profiles/home-manager" result/home
    dix diff /nix/var/nix/profiles/system result/system

activate host=`hostname`: (build host)
    ./result/home/activate
    sudo ./result/system/activate
