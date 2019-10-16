add-zsh-hook chpwd ls_limited

command_not_found_handler() {
    local cmd=$1
    if [[ $cmd =~ ^git ]]; then
        local subcommand=$2
        shift
        shift
        subcommand="${cmd#git}$subcommand"
        exec git $subcommand "$@"
    fi

    echo "command '$cmd' not found"

    local pkgs
    pkgs=(${(f)"$(which pkgfile &>/dev/null && pkgfile -b -v -- "$cmd" 2>/dev/null)"})
    if [[ -n "$pkgs" ]]; then
        printf '%s may be found in the following packages:\n' "$cmd"
        printf '  %s\n' $pkgs[@]
        return 0
    fi
    return 127
}

write_sqlite_history() {
    local entry=$1
    __running_histcmd=$HISTCMD

    if [[ $1 == ${~HISTORY_IGNORE} ]] ; then
        __running_histcmd=''
        return
    fi

    ~/.zsh-scripts/hist-append.pl "$(hostname)" "$$" "$(date +'%s')" $HISTCMD "$(pwd)" "$entry" || echo "Failed to write SQLite history - fix me!"
}

add-zsh-hook zshaddhistory write_sqlite_history

write_sqlite_history_onexit() {
    if [[ $1 == ${~HISTORY_IGNORE} ]] ; then
        return
    fi

    ~/.zsh-scripts/hist-append.pl "$(hostname)" "$$" "$(date +'%s')" $HISTCMD "$(pwd)" "exit" || echo "Failed to write SQLite history - fix me!"
}

add-zsh-hook zshexit write_sqlite_history_onexit

update_sqlite_history() {
    local __exit_status=$?

    if [[ -z "$__running_histcmd" ]] ; then
        return
    fi

    # XXX not sure how to handle ctrl-c on the command line...

    ~/.zsh-scripts/hist-update.pl "$(hostname)" "$$" $__running_histcmd "$(date +'%s')" $__exit_status
}

add-zsh-hook precmd update_sqlite_history
