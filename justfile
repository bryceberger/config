alias n := nix

nix:
    sudo nixos-rebuild switch --flake .

alias h := home

home:
    home-manager switch --flake .

alias u := both

both:
    @just nix
    @just home
