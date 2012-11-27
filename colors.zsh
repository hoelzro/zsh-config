setopt prompt_subst

function __git_prompt {
    if git status &>/dev/null; then
        local branch=$(git branch --color=never | sed -ne 's/* //p')

        if git status -uno -s | grep -q . ; then
            echo -n "[%B%F{red}$branch%f%b] "
        else
            echo -n "[%B%F{green}$branch%f%b] "
        fi
    fi
}

PS1="\$(__git_prompt)%F{cyan}[%*] %F{green}%n@%m %F{blue}%~ \$ %f"
