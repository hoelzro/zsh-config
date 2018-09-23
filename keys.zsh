autoload -U edit-command-line
zle -N edit-command-line

bindkey -N custom viins
bindkey -A custom main

bindkey -M custom '^U' backward-kill-line
bindkey -M custom ${terminfo[kdch1]} delete-char
bindkey -M custom '^X^E' edit-command-line

function _fat_finger_bang4_expand() {
    LBUFFER=${LBUFFER/%\!4/\!$}
    zle expand-or-complete
}

zle -N fat_finger_bang4_expand _fat_finger_bang4_expand

bindkey -M custom '^I' fat_finger_bang4_expand
