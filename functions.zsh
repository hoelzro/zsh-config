LS_LIMIT=400
function ls_limited()
{
    if [[ $ZSH_SUBSHELL -ne 0 ]]; then
        return
    fi

    local file_count

    file_count=`ls | wc -l`
    if [[ $file_count -gt $LS_LIMIT ]]; then
        echo "Over $LS_LIMIT files were found; listing the newest $LS_LIMIT"
        ls -tr $__LS_FLAGS | tail -n $LS_LIMIT
    else
        ls -tr $__LS_FLAGS
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

    if [[ $# -eq 1 && $previous_command =~ ^git && $previous_command =~ clone ]]; then
        if [[ ! -d $1 ]]; then
            local destination=$1
            local proto_source
            local path_pieces
            local final_piece

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

function p {
    ps aux | grep -i $1
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

function gcv {
    local num_changes
    local invocation
    local threshold=1000

    num_changes=$(git diff-index --cached --numstat HEAD | perl -anE '$sum += $F[0] + $F[1]; END { say $sum }')

    if [[ $num_changes -ge $threshold ]]; then
        invocation="git commit -uno -t <(echo -n \"\n# You have more than $threshold changes; use gcvv to see the changes anyway\")"
    else
        invocation='git commit -uno -v'
    fi

    eval $invocation "$*"
}

function mount {
    if [[ $# -eq 0 ]]; then
        findmnt -c -t noautofs,nobinfmt_misc,nosecurityfs,nocgroup,nocgroup2,nodebugfs,noconfigfs,nofusectl,nodevpts,nomqueue,nohugetlbfs,nofuse.gvfsd-fuse,nopstore
    else
        command mount "$@"
    fi
}

function conf {
    local project=$(basename $(pwd))

    if [[ $project == 'rakudo' ]]; then
        perl Configure.pl --git-reference=$HOME/projects --prefix=/tmp/nom --gen-moar
    elif [[ $project == 'nqp' ]]; then
        perl Configure.pl --git-reference=$HOME/projects --prefix=/tmp/nom --gen-moar
    elif [[ $project == 'MoarVM' ]]; then
        perl Configure.pl --git-reference=$HOME/projects --prefix=/tmp/nom --gen-moar
    else
        echo "Unrecognized project '$project'"
        return 1
    fi
}

# functions that automatically augment path

function _augment-path {
    local add_to_path=$1
    shift
    local caller=${funcstack[2]}

    which $caller &>/dev/null
    if [[ $? -ne 0 ]]; then
        export PATH=$PATH:$add_to_path
        unhash -f $caller
    fi
    command $caller $*
}

function perl6 {
    _augment-path "$HOME/.mokudo/bin:/home/rob/.mokudo/share/perl6/site/bin" $*
}

function panda {
    _augment-path "$HOME/.mokudo/bin:/home/rob/.mokudo/share/perl6/site/bin" $*
}

function elm-make {
    _augment-path "/home/rob/.elm-platform/Elm-Platform/0.16/.cabal-sandbox/bin:/home/rob/.elm-platform/node_modules/.bin/" $*
}

function elm-reactor {
    _augment-path "/home/rob/.elm-platform/Elm-Platform/0.16/.cabal-sandbox/bin:/home/rob/.elm-platform/node_modules/.bin/" $*
}

function elm-repl {
    _augment-path "/home/rob/.elm-platform/Elm-Platform/0.16/.cabal-sandbox/bin:/home/rob/.elm-platform/node_modules/.bin/" $*
}

function run-help-aws {
    aws $* help
}
