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

# rbenv
if [[ -d ~/.rbenv ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - --no-rehash)"
fi

# virtual env
if [[ -e /usr/bin/virtualenvwrapper_lazy.sh ]]; then
    source /usr/bin/virtualenvwrapper_lazy.sh
elif [[ -e /usr/bin/virtualenvwrapper.sh ]]; then
    source /usr/bin/virtualenvwrapper.sh
fi

fpath=("$HOME/.zsh-scripts/Completion/" $fpath)
autoload -U compinit
compinit

# Awesome URL quoting magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Autojump
if [[ -e /usr/etc/profile.d/autojump.zsh ]]; then
    source /usr/etc/profile.d/autojump.zsh
elif [[ -e /etc/profile.d/autojump.zsh ]]; then
    source /etc/profile.d/autojump.zsh
elif [[ ! -z "$__BREW_ROOT" ]] && [[ -e "$__BREW_ROOT/etc/autojump.zsh" ]]; then
    source $__BREW_ROOT/etc/autojump.zsh
fi

autoload -U add-zsh-hook

source ~/.zsh-scripts/options.zsh
source ~/.zsh-scripts/colors.zsh
source ~/.zsh-scripts/functions.zsh
source ~/.zsh-scripts/aliases.zsh
source ~/.zsh-scripts/env.zsh
source ~/.zsh-scripts/hooks.zsh
source ~/.zsh-scripts/keys.zsh

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

# Load help...helpers
unalias run-help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-sudo

# XXX Bash::Completion plugins

ls_limited
