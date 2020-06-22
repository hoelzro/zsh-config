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
        elif hg branch &>/dev/null; then
            vcs_type=hg
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
        branch=$(git branch --color=never | sed -ne 's/* //p')

        # I hope this stays stable...
        if [[ $branch == '(no branch)' ]] ; then
            local repo_root=$(git rev-parse --show-toplevel)
            if [[ -e "$repo_root/.git/rebase-merge" ]]; then
                branch='(rebasing)'
            elif [[ -e "$repo_root/.git/BISECT_START" ]] ; then
                branch='(bisecting)'
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
    elif [[ $vcs_type == hg ]]; then
        branch=$(hg branch)
        if hg status --quiet | grep -q . ; then
            echo -n "[%B%F{red}hg:$branch%f%b] "
        else
            echo -n "[%B%F{green}hg:$branch%f%b] "
        fi
    fi
}

__vi_mode=main

function zle-line-init {
    __vi_mode=$KEYMAP
    zle reset-prompt
}

function zle-keymap-select {
    __vi_mode=$KEYMAP
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

PS1="\$([[ \$__vi_mode == 'vicmd' ]] && echo %U)%(2j.(%j jobs running) .%(1j.(1 job running) .))\$(__vcs_prompt)%F{cyan}[%*] %F{green}%n@%m %F{blue}%~ \$ %f\$([[ \$__vi_mode == 'vicmd' ]] && echo %u)"
