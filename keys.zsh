autoload -U edit-command-line
zle -N edit-command-line

bindkey -v
bindkey '^B' backward-word
bindkey '^F' forward-word
bindkey '^U' backward-kill-line
bindkey ${terminfo[kdch1]} delete-char
bindkey '^X^E' edit-command-line
