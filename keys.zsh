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

function _pacsearch_replace() {
    local first_word

    first_word=${${(z)LBUFFER}[1]}

    if [[ "$first_word" == 'pacman' ]]; then
        local num_words second_word

        num_words=${#${(z)LBUFFER}}
        second_word=${${(z)LBUFFER}[2]}

        if [[ $num_words -eq 2 && "$second_word" == '-Ss' ]]; then
            LBUFFER='pacsearch'
        fi
    fi

    zle self-insert
}

function _remove_pacsearch_replace_and_search_backward() {
    bindkey -M custom ' ' self-insert
    zle vi-history-search-backward
    bindkey -M custom ' ' pacsearch_replace
}

function _remove_pacsearch_replace_and_search_forward() {
    bindkey -M custom ' ' self-insert
    zle vi-history-search-forward
    bindkey -M custom ' ' pacsearch_replace
}

zle -N fat_finger_bang4_expand _fat_finger_bang4_expand
zle -N pacsearch_replace _pacsearch_replace
zle -N remove_pacsearch_replace_and_search_backward _remove_pacsearch_replace_and_search_backward
zle -N remove_pacsearch_replace_and_search_forward _remove_pacsearch_replace_and_search_forward

bindkey -M custom '^I' fat_finger_bang4_expand
bindkey -M custom ' ' pacsearch_replace
bindkey -M vicmd '/' remove_pacsearch_replace_and_search_backward
bindkey -M vicmd '?' remove_pacsearch_replace_and_search_forward
