setopt prompt_subst

function __vcs_prompt {
    if git status &>/dev/null; then
        local branch
        branch=$(git branch --color=never | sed -ne 's/* //p')

        if git status -uno -s | grep -q . ; then
            echo -n "[%B%F{red}$branch%f%b] "
        else
            echo -n "[%B%F{green}$branch%f%b] "
        fi
    elif hg status &>/dev/null; then
        local branch
        branch=$(hg branch)

        if hg status --quiet | grep -q . ; then
            echo -n "[%B%F{red}$branch%f%b] "
        else
            echo -n "[%B%F{green}$branch%f%b] "
        fi
    fi
}

PS1="\$(__vcs_prompt)%F{cyan}[%*] %F{green}%n@%m %F{blue}%~ \$ %f"
