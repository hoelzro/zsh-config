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

# RVM
if [[ -e ~/.rvm/scripts/rvm ]]; then
    source ~/.rvm/scripts/rvm
    alias rvm="PAGER=less rvm"
fi

autoload -U compinit
compinit

# Autojump
if [[ -e /usr/etc/profile.d/autojump.zsh ]]; then
    source /usr/etc/profile.d/autojump.zsh
elif [[ -e /etc/profile.d/autojump.zsh ]]; then
    source /etc/profile.d/autojump.zsh
elif [[ ! -z "$__BREW_ROOT" ]] && [[ -e "$__BREW_ROOT/etc/autojump.zsh" ]]; then
    source $__BREW_ROOT/etc/autojump.zsh
fi

source ~/.zsh-scripts/options.zsh
source ~/.zsh-scripts/colors.zsh
source ~/.zsh-scripts/functions.zsh
source ~/.zsh-scripts/aliases.zsh
source ~/.zsh-scripts/env.zsh
source ~/.zsh-scripts/hooks.zsh
source ~/.zsh-scripts/keys.zsh

# Site-specific customizations
if [[ -e ~/.bashrc_scripts/local.sh ]]; then
    source ~/.bashrc_scripts/local.sh
fi

# XXX Bash::Completion plugins

ls_limited
