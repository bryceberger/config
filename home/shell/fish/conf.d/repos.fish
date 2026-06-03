# stored in conf.d/ instead of functions/ to export multiple functions

function _r_date -a repo
    if test -d "$repo/.jj"
        date --iso-8601=seconds >$repo/.jj/last-accessed
    end
end

function ri
    set -l short (jj-manage list | fzf); or return 1
    set -l base (jj-manage base)
    _r_date "$base/$short"
    cd "$base/$short"
end

function r
    set -l full (jj-manage resolve --long $argv || return 1)
    _r_date "$full"
    cd "$full"
end
complete -c r -f
complete -c r -a "(jj-manage list)"

function rt
    set -l now (date +%s)
    set -l base (jj-manage base)
    set -l rs (printf "\x1e")
    for repo in (jj-manage list)
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

function __fzf_jj_ref
    set template 'format_short_change_id_with_change_offset(self) ++ " " ++ format_short_signature_oneline(self.author()) ++ " "++ self.description().first_line() ++ "\0" ++ format_short_change_id_with_change_offset(self)'
    set refs (jj log --color=always -T $template | fzf --with-nth 1 --accept-nth 2 --delimiter '\0' \
    --height 50% --tmux 90%,70% \
    --layout reverse --multi --min-height 20+ \
    --preview-window 'right,50%' \
    --bind 'ctrl-/:change-preview-window(down,50%|hidden|)'  --ansi \
    --no-hscroll --preview "jj show --color=always {2}")
    if test $status -eq 0
        commandline --insert (string join ' ' $refs)
    end
    commandline --function repaint
end
bind \cg __fzf_jj_ref
