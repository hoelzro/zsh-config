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

    local pkgs
    pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
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

    ~/.zsh-scripts/hist-append.pl "$(hostname)" "$$" "$(date +'%s')" $HISTCMD "$(pwd)" "$entry" || echo "Failed to write SQLite history - fix me!"
}

zshaddhistory_functions[$(($#zshaddhistory_functions + 1))]=write_sqlite_history
