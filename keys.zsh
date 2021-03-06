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

function _slash_show_relative_destination() {
    zle self-insert

    local first_word
    first_word=${${(z)LBUFFER}[1]}

    if [[ "$first_word" == 'cd' ]] ; then
        local num_words second_word
        num_words=${#${(z)LBUFFER}}
        second_word=${${(z)LBUFFER}[2]}

        if [[ $num_words -eq 2 ]]; then
            zle -M ${${~second_word}:P}
        fi
    fi
}

function _remove_magic_keys_and_search_backward() {
    bindkey -M custom ' ' self-insert
    bindkey -M custom '/' self-insert
    zle vi-history-search-backward
    bindkey -M custom ' ' pacsearch_replace
    bindkey -M custom '/' slash_show_relative_destination
}

function _remove_magic_keys_and_search_forward() {
    bindkey -M custom ' ' self-insert
    bindkey -M custom '/' self-insert
    zle vi-history-search-forward
    bindkey -M custom ' ' pacsearch_replace
    bindkey -M custom '/' slash_show_relative_destination
}

zle -N fat_finger_bang4_expand _fat_finger_bang4_expand
zle -N pacsearch_replace _pacsearch_replace
zle -N slash_show_relative_destination _slash_show_relative_destination
zle -N remove_magic_keys_and_search_backward _remove_magic_keys_and_search_backward
zle -N remove_magic_keys_and_search_forward _remove_magic_keys_and_search_forward

bindkey -M custom '^I' fat_finger_bang4_expand
bindkey -M custom ' ' pacsearch_replace
bindkey -M custom '^[[11~' run-help
bindkey -M custom '^O' push-line
bindkey -M custom '/' slash_show_relative_destination
bindkey -M vicmd '/' remove_magic_keys_and_search_backward
bindkey -M vicmd '?' remove_magic_keys_and_search_forward

bindkey -M vicmd 'j' down-history
bindkey -M vicmd 'k' up-history
bindkey -M vicmd 'gj' down-line-or-history
bindkey -M vicmd 'gk' up-line-or-history

bindkey -M custom -r '^[OA'
bindkey -M custom -r '^[OB'
bindkey -M custom -r '^[[A'
bindkey -M custom -r '^[[B'
bindkey -M vicmd -r '^[OA'
bindkey -M vicmd -r '^[OB'
bindkey -M vicmd -r '^[[A'
bindkey -M vicmd -r '^[[B'

bindkey -M viopp "i'" select-in-shell-word
