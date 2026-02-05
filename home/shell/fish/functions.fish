function s --wraps "rg --json"
    rg --json $argv | delta --tabs 1
end

function _r_date -a repo
    if test -d "$repo/.jj"
        date --iso-8601=seconds >$repo/.jj/last-accessed
    end
end

function ri
    set -l short (@jjm@ list | @fzf@); or return 1
    set -l base (@jjm@ base)
    _r_date "$base/$short"
    cd "$base/$short"
end

function r
    set -l full (@jjm@ resolve --long $argv || return 1)
    _r_date "$full"
    cd "$full"
end
complete -c r -f
complete -c r -a "(@jjm@ list)"

function rt
    set -l now (date +%s)
    set -l base (@jjm@ base)
    set -l rs (printf "\x1e")
    for repo in (@jjm@ list)
        if test -f "$base/$repo/.jj/last-accessed"
            set -l then (date --date=(cat "$base/$repo/.jj/last-accessed") +%s)
            set -l diff (math $now - $then)

            set -l days (math "floor($diff / 86400)")
            set -l hours (math "floor(($diff % 86400) / 3600)")
            set -l minutes (math "floor((($diff % 86400) % 3600) / 60)")
            set -l seconds (math "floor((($diff % 86400) % 3600) % 60)")

            printf "$diff$rs$repo$rs%dd %02dh %02dm %02ds ago\n" $days $hours $minutes $seconds
        end
    end | sort -n | cut -d"$rs" -f"2,3" | column -t -s"$rs" -R 2
end

function bind_bang
    switch (commandline --current-token)[-1]
        case "!"
            commandline --current-token -- $history[1]
        case "*"
            commandline --insert !
    end
end
bind ! bind_bang

function bind_question
    switch (commandline --current-token)[-1]
        case "\$"
            commandline --current-token -- "\$status"
        case "*"
            commandline --insert \?
    end
end
bind \? bind_question

function tmp
    set -l tmpdir (mktemp -d)
    cd $tmpdir
    fish $argv
    set -l ret $status
    cd $dirprev[-1]
    return $ret
end
