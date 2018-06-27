autoload -U edit-command-line
zle -N edit-command-line

bindkey -v
bindkey '^U' backward-kill-line
bindkey ${terminfo[kdch1]} delete-char
bindkey '^X^E' edit-command-line

function _fat_finger_bang4_expand() {
    LBUFFER=${LBUFFER/%\!4/\!$}
    zle expand-or-complete
}

zle -N fat_finger_bang4_expand _fat_finger_bang4_expand

bindkey -M viins '^I' fat_finger_bang4_expand
