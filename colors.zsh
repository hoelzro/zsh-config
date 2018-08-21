setopt prompt_subst

function __vcs_prompt {
    local branch
    local upstream_relationship

    if git rev-parse --is-inside-work-tree &>/dev/null; then
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
    elif branch=$(hg branch 2>/dev/null); then
        if hg status --quiet | grep -q . ; then
            echo -n "[%B%F{red}hg:$branch%f%b] "
        else
            echo -n "[%B%F{green}hg:$branch%f%b] "
        fi
    fi
}

PS1="%(2j.(%j jobs running) .%(1j.(1 job running) .))\$(__vcs_prompt)%F{cyan}[%*] %F{green}%n@%m %F{blue}%~ \$ %f"
