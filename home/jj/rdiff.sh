#!/usr/bin/env bash
set -eu -o pipefail

fail() {
    echo "$@"
    exit 1
}

target=$1

# todo: configurable stream head
# \x1f -> unit separator
bookmark_names=$(jj log --no-graph -r "exactly(heads((trunk()..$target):: & bookmarks()), 1)" -T 'local_bookmarks.map(|l| l.name() ++ "\x1f")')
IFS=$'\x1f' read -ra bookmarks <<<"$bookmark_names"
[ ${#bookmarks[@]} -eq 1 ] || fail "more than one bookmark found:" "${bookmarks[@]}"
bookmark=${bookmarks[0]}

all_refs=$(jj evolog --no-graph -T 'commit.commit_id() ++ "|"' -r "$target")
# todo: configurable remote
remote=$(jj log --no-graph -T 'commit_id' -n 1 -r "($all_refs none()) & ::$bookmark@origin")

jj interdiff --from "$remote" --to "$target" "${@:2}"
