#! /usr/bin/env bash
# nixpkgs `pkgs/build-support/fetchgit/nix-prefetch-git`

set -eu -o pipefail

url=$1
shift
read -ra revs <<<"$*"

branch_name=fetchgit2

# ENV params
: "${out:?}"
http_proxy=${http_proxy:-}

# NOTE: use of NIX_GIT_SSL_CAINFO is for backwards compatibility; NIX_SSL_CERT_FILE is preferred
# as of PR#303307
export GIT_SSL_CAINFO=${NIX_GIT_SSL_CAINFO:-$NIX_SSL_CERT_FILE}

# some git commands print to stdout, which would contaminate our JSON output
clean_git() {
    git "$@" >&2
}

if test -z "$url"; then
    usage
fi

init_remote() {
    local url=$1
    clean_git init --initial-branch=master
    clean_git remote add origin "$url"
    ([ -n "$http_proxy" ] && clean_git config --global http.proxy "$http_proxy") || true
    local proxy_pairs i
    read -ra proxy_pairs <<<"${FETCHGIT_HTTP_PROXIES:-}"
    for ((i = 1; i < ${#proxy_pairs[@]}; i += 2)); do
        clean_git config --global "http.${proxy_pairs[$i - 1]}.proxy" "${proxy_pairs[$i]}"
    done
}

clone() {
    local top=$PWD
    local dir="$1"
    local url="$2"
    shift 2
    local refs=("$@")

    cd "$dir"

    # Initialize the repository.
    init_remote "$url"

    # Download data from the repository.
    for ref in "${refs[@]}"; do
        clean_git fetch --progress --depth 100 origin +"$ref" || return 1
    done
    clean_git config user.email "nix-prefetch-git@localhost"
    clean_git config user.name "nix-prefetch-git"
    clean_git checkout -b "$branch_name" "${refs[0]}" || return 1
    clean_git merge --allow-unrelated-histories "${refs[@]}" || (
        echo 1>&2 "unable to merge"
        exit 1
    )

    cd "$top"
}

# Remove all remote branches, remove tags not reachable from HEAD, do a full
# repack and then garbage collect unreferenced objects.
make_deterministic_repo() {
    local repo="$1"

    # run in sub-shell to not touch current working directory
    (
        cd "$repo"
        # Remove files that contain timestamps or otherwise have non-deterministic
        # properties.
        if [ -f .git ]; then
            local dotgit_content
            dotgit_content=$(<.git)
            local dotgit_dir="${dotgit_content#gitdir: }"
        else
            local dotgit_dir=".git"
        fi
        pushd "$dotgit_dir" >/dev/null
        rm -rf logs/ hooks/ index FETCH_HEAD ORIG_HEAD refs/remotes/origin/HEAD config
        popd >/dev/null
        # Remove all remote branches.
        git branch -r | while read -r branch; do
            clean_git branch -rD "$branch"
        done

        # Remove tags not reachable from HEAD. If we're exactly on a tag, don't
        # delete it.
        maybe_tag=$(git tag --points-at HEAD)
        git tag --contains HEAD | while read -r tag; do
            if [ "$tag" != "$maybe_tag" ]; then
                clean_git tag -d "$tag"
            fi
        done

        # Do a full repack. Must run single-threaded, or else we lose determinism.
        clean_git config pack.threads 1
        clean_git repack -A -d -f
        rm -f "$dotgit_dir/config"

        # Garbage collect unreferenced objects.
        # Note: --keep-largest-pack prevents non-deterministic ordering of packs
        #   listed in .git/objects/info/packs by only using a single pack
        clean_git gc --prune=all --keep-largest-pack
    )
}

clone_user_rev() {
    local dir="$1"
    clone "$@" 1>&2
    echo "removing \`.git\`..." >&2
    find "$dir" -name .git -print0 | xargs -0 rm -rf
}

unset HOME
unset XDG_CONFIG_HOME
export GIT_CONFIG_NOSYSTEM=1

mkdir -p "$out"
clone_user_rev "$out" "$url" "${revs[@]}"
