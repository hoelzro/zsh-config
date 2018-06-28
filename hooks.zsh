typeset -a chpwd_functions

chpwd_functions[$(($#chpwd_functions + 1))]=ls_limited

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

typeset -a zshaddhistory_functions

write_sqlite_history() {
    local entry=$1

    if [[ $1 == ${~HISTORY_IGNORE} ]] ; then
        return
    fi

    ~/.zsh-scripts/hist-append.pl "$(hostname)" "$$" "$(date +'%s')" $HISTCMD "$(pwd)" "$entry" || echo "Failed to write SQLite history - fix me!"
}

zshaddhistory_functions[$(($#zshaddhistory_functions + 1))]=write_sqlite_history

typeset -a zshexit_functions

write_sqlite_history_onexit() {
    if [[ $1 == ${~HISTORY_IGNORE} ]] ; then
        return
    fi

    ~/.zsh-scripts/hist-append.pl "$(hostname)" "$$" "$(date +'%s')" $HISTCMD "$(pwd)" "exit" || echo "Failed to write SQLite history - fix me!"
}

zshexit_functions[$(($#zshexit_functions + 1))]=write_sqlite_history_onexit
