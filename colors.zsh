setopt prompt_subst

function __vcs_prompt {
    if git status &>/dev/null; then
        local branch
        branch=$(git branch --color=never | sed -ne 's/* //p')

        # I hope this stays stable...
        if [[ $branch == '(no branch)' ]] ; then
            local repo_root=$(git rev-parse --show-toplevel)
            if [[ -e "$repo_root/.git/rebase-merge" ]]; then
                branch='(rebasing)'
            elif [[ -e "$repo_root/.git/BISECT_START" ]] ; then
                branch='(bisecting)'
            fi
        fi

        if git status --untracked-files=no --short | grep -q . ; then
            echo -n "[%B%F{red}git:$branch%f%b] "
        else
            echo -n "[%B%F{green}git:$branch%f%b] "
        fi
    elif hg status &>/dev/null; then
        local branch
        branch=$(hg branch)

        if hg status --quiet | grep -q . ; then
            echo -n "[%B%F{red}hg:$branch%f%b] "
        else
            echo -n "[%B%F{green}hg:$branch%f%b] "
        fi
    fi
}

PS1="\$(__vcs_prompt)%F{cyan}[%*] %F{green}%n@%m %F{blue}%~ \$ %f"
