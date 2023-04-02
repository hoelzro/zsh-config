setopt prompt_subst

typeset -g -A __dir_vcs_type

function __setup_zsh_prompt() {
    local wd
    local vcs_type

    wd=$(pwd)
    vcs_type=$__dir_vcs_type[$wd]

    if [[ -z "$vcs_type" ]]; then
        if git rev-parse --is-inside-work-tree 2>/dev/null | grep -q true; then
            vcs_type=git
        else
            vcs_type=none
        fi
        __dir_vcs_type[$wd]=$vcs_type
    fi
}

add-zsh-hook precmd __setup_zsh_prompt

function __vcs_prompt {
    local branch
    local upstream_relationship
    local wd
    local vcs_type

    wd=$(pwd)

    vcs_type=$__dir_vcs_type[$wd]

    if [[ $vcs_type == git ]]; then
        branch=$(git branch --show-current)

        if [[ $branch == '' ]] ; then
            local repo_root=$(git rev-parse --show-toplevel)
            if [[ -e "$repo_root/.git/rebase-merge" ]]; then
                branch='(rebasing)'
            elif [[ -e "$repo_root/.git/BISECT_START" ]] ; then
                branch='(bisecting)'
            else
                branch="$(git log -1 --decorate=full --pretty=format:%h\ %D | perl -anle 'print $1 if m{refs/tags/([^,]+)}; print "HEAD detached at $F[0]"' | head -1)"
            fi
        else
            upstream_relationship=$(git for-each-ref --format='%(upstream:track)' "refs/heads/$branch" | perl -CSAD -Mutf8 -nE 'chomp; $ahead = "↑$1" if /ahead\s+(\d+)/; $behind = "↓$1" if /behind\s+(\d+)/; say $ahead . $behind')
        fi

        if git status --untracked-files=no --short | grep -q . ; then
            echo -n "[%B%F{red}git:$branch$upstream_relationship%f%b] "
        elif [[ "$upstream_relationship" != '' ]]; then
            echo -n "[%B%F{yellow}git:$branch$upstream_relationship%f%b] "
        else
            echo -n "[%B%F{green}git:$branch$upstream_relationship%f%b] "
        fi
    fi
}

__vi_mode=main

function zle-line-init {
    __vi_mode=$KEYMAP
    zle reset-prompt

    setopt local_options
    setopt extendedglob

    local duration=$(fc -lDn -1 -1)
    duration=${duration/(#b)0#([[:digit:]]##):0#([[:digit:]]##)*/$(( $match[1] * 60 + $match[2] ))}
    if [[ $duration -ge 10 ]] ; then
        echo -n "%{\a%}"
    fi
}

function zle-keymap-select {
    __vi_mode=$KEYMAP
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

PS1="\$([[ \$__vi_mode == 'vicmd' ]] && echo %U)%(2j.(%j jobs running) .%(1j.(1 job running) .))\$(__vcs_prompt)%F{cyan}[%*] %F{green}%n@%m %F{blue}%~ \$ %f\$([[ \$__vi_mode == 'vicmd' ]] && echo %u)"

# highlight global aws-cli options in a light grey
zstyle ':completion:*:aws:*' list-colors '=--(debug|endpoint-url|no-verify-ssl|no-paginate|output|query|profile|region|version|color|no-sign-request|ca-bundle|cli-read-timeout|cli-connect-timeout)=38;5;242'
