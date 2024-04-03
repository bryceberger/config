if not status is-interactive
    exit
end

function get_focused_window_id
    if set -q HYPRLAND_INSTANCE_SIGNATURE
        hyprctl -j activewindow | jq ".address"
    else
        echo 12345
    end
end

function __done_humanize_duration -a milliseconds
    set -l seconds (math --scale=0 "$milliseconds/1000" % 60)
    set -l minutes (math --scale=0 "$milliseconds/60000" % 60)
    set -l hours (math --scale=0 "$milliseconds/3600000")

    if test $hours -gt 0
        printf '%s' $hours'h '
    end
    if test $minutes -gt 0
        printf '%s' $minutes'm '
    end
    if test $seconds -gt 0
        printf '%s' $seconds's'
    end
end

function __done_is_process_window_focused
    # Return false if the window is not focused

    if set -q __done_allow_nongraphical
        return 1
    end

    set __done_focused_window_id (get_focused_window_id)
    if test "$__done_initial_window_id" != "$__done_focused_window_id"
        return 1
    end

    return 0
end

set -g __done_initial_window_id ''

function done_start --on-event fish_preexec
    set __done_initial_window_id (get_focused_window_id)
end

function done_end --on-event fish_prompt
    set -l exit_status $status
    set -q cmd_duration; or set -l cmd_duration $CMD_DURATION
    set -q __done_min_cmd_duration; or set -g __done_min_cmd_duration 5000

    if test $cmd_duration
            and test $cmd_duration -gt $__done_min_cmd_duration
            and not __done_is_process_window_focused

        set -l humanized_duration (__done_humanize_duration "$cmd_duration")
        
        set -l title "Done in $humanized_duration"
        set -l wd (string replace --regex "^$HOME" "~" (pwd))
        set -l message "$wd/ $history[1]"
        set -l sender $__done_initial_window_id

        if test $exit_status -ne 0
            set title "Failed ($exit_status) after $humanized_duration"
        end

        if set -q __done_notification_command
            eval $__done_notification_command
        else if type -q notify-send # Linux notify-send
            # set urgency to normal
            set -l urgency normal

            # use user-defined urgency if set
            if set -q __done_notification_urgency_level
                set urgency "$__done_notification_urgency_level"
            end
            # override user-defined urgency level if non-zero exitstatus
            if test $exit_status -ne 0
                set urgency critical
                if set -q __done_notification_urgency_level_failure
                    set urgency "$__done_notification_urgency_level_failure"
                end
            end

            notify-send -e --urgency=$urgency --icon=utilities-terminal --app-name=fish "$title" "$message"
        end
    end
end
