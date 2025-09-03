function s --wraps "rg --json"
    rg --json $argv | delta --tabs 1
end

function ri
    set -l short (@jjm@ list | @fzf@); or return 1
    set -l base (@jjm@ base)
    cd "$base/$short"
end

function r
    set -l full (@jjm@ resolve --long $argv || return 1)
    cd "$full"
end
complete -c r -f
complete -c r -a "(@jjm@ list)"

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
