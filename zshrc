if [[ $(uname) == 'Darwin' ]]; then # if we're on OS X
    __LS_FLAGS='-G'
else
    __LS_FLAGS='--color=auto'
fi

if which brew &>/dev/null; then # if Homebrew is installed
    __BREW_ROOT=$(brew --prefix)
fi

# Perlbrew
if [[ -e ~/.perlbrew/etc/bashrc ]]; then
    source ~/.perlbrew/etc/bashrc
fi

fpath=("$HOME/.zsh-scripts/Completion/" "$HOME/.zsh-scripts/Functions/Local" "$HOME/.zsh-scripts/Functions/" $fpath)
autoload -U compinit
compinit

# Awesome URL quoting magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -U add-zsh-hook

source ~/.zsh-scripts/options.zsh
source ~/.zsh-scripts/colors.zsh
source ~/.zsh-scripts/functions.zsh
source ~/.zsh-scripts/aliases.zsh
source ~/.zsh-scripts/env.zsh
source ~/.zsh-scripts/hooks.zsh
source ~/.zsh-scripts/keys.zsh

function _ls() {
    typeset -a args
    local needs_dash_d=false

    while [[ $# -gt 0 ]] ; do
        if [[ ${1[-1,-1]} == '*' || ${1[-2,-1]} == '*/' ]] ; then
            needs_dash_d=true
        fi
        args=( ${args[@]} ${~1} )
        shift
    done

    if $needs_dash_d ; then
        args=( -d ${args[@]} )
    fi

    command ls "${args[@]}"
}
alias ls="noglob _ls $__LS_FLAGS"

# Site-specific customizations
if [[ -e ~/.zsh-scripts/local.zsh ]]; then
    source ~/.zsh-scripts/local.zsh
fi

zstyle ':completion:*:processes' command "ps -a -U $(whoami)"

zstyle ':completion:*:globbed-files' ignored-patterns \
    '*.o' \
    '*.ibc' \
    '*.hi' \
    '*.elmi' \
    '*.elmo'

zstyle ':completion:*:cd:*' file-sort 'reverse modification'

zstyle ':completion:*:*:sqlite3:*:*' file-patterns '*.(db|sqlite):database-files' '%p:all-files'

# Load help...helpers
unalias run-help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-sudo

autoload -Uz memo
autoload -Uz find-existing-vim-session
autoload -Uz comp-iterate

# XXX Bash::Completion plugins

ls_limited
check-dotfiles-sync-status
