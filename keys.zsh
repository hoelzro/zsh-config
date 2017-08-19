autoload -U edit-command-line
zle -N edit-command-line

bindkey -v
bindkey -M vicmd '/' history-incremental-search-backward
bindkey '^U' backward-kill-line
bindkey ${terminfo[kdch1]} delete-char
bindkey '^X^E' edit-command-line
