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
    return 127
}
