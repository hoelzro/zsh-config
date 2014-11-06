LS_LIMIT=400
function ls_limited()
{
    if [[ $ZSH_SUBSHELL -ne 0 ]]; then
        return
    fi

    local file_count

    file_count=`ls | wc -l`
    if [[ $file_count -gt $LS_LIMIT ]]; then
	echo "Over $LS_LIMIT files were found; listing the first $LS_LIMIT"
	ls $__LS_FLAGS | head -$LS_LIMIT
    else
	ls $__LS_FLAGS
    fi
}

function knock {
    for port in $2 $3 $4; do
        nc $1 $port
        sleep 1
    done
}

function ov {
    sudo openvpn "/etc/openvpn/$1.conf"
}

# I often type this by mistake instead of !p
function 1p {
    local command
    command=$(fc -l -n 1 -1 | sed -n -e '/^p/{p;q}')
    echo "$command"
    eval "$command"
}

function fg {
    if [[ $# == 1 && $1 == <-> ]] ; then
        builtin fg "%$1"
        return $?
    fi
    builtin fg
}

function bg {
    if [[ $# == 1 && $1 == <-> ]] ; then
        builtin bg "%$1"
        return $?
    fi
    builtin bg
}

function cd {
    local previous_command

    previous_command=$(fc -nl -1 -1)

    if [[ $previous_command =~ ^git && $previous_command =~ clone ]]; then
        if [[ ! -d $1 ]]; then
            local destination=$1
            local proto_source
            local path_pieces
            local final_piece

            echo "cd'ing to $destination"
            proto_source=(${${(@s.:.)destination}})
            if [ ${#proto_source} -eq 2 ]; then
                destination=${proto_source[2]}
            fi
            destination=${destination%.git}
            path_pieces=(${${(@s./.)destination}})
            final_piece=${path_pieces[-1]}
            builtin cd "$final_piece"
            return
        fi
    fi
    builtin cd "$@"
}

function which {
    command which "$@"
}

function e {
    env | grep -i $1 | sort
}

function man {
    local size
    local columns

    setopt   local_options
    unsetopt bash_rematch

    size=$(stty size </dev/tty)
    [[ "$size" =~ '[0-9]+$' ]]
    columns=$MATCH
    export MANWIDTH=$(( $columns - 5 ))
    command man "$@"
}
