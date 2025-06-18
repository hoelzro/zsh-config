autoload -U edit-command-line
zle -N edit-command-line

bindkey -N custom viins
bindkey -A custom main

bindkey -M custom '^U' backward-kill-line
bindkey -M custom ${terminfo[kdch1]} delete-char
bindkey -M custom '^X^E' edit-command-line
bindkey -M custom '^Xu' undo

function _fat_finger_bang4_expand() {
    LBUFFER=${LBUFFER/%\!4/\!$}
    zle expand-or-complete
}

function _common_replacements() {
    local words=(${(z)LBUFFER})
    local first_word=${words[1]}

    if [[ "$first_word" == 'pacman' ]]; then
        local num_words=${#words}
        local second_word=${words[2]}

        if [[ $num_words -eq 2 && "$second_word" == '-Ss' ]]; then
            LBUFFER='pacsearch'
        fi
    elif [[ "$first_word" == 'journalctl' && ${words[-1]} == '-E' ]] ; then
        words[-1]='-U'
        LBUFFER=${(j: :)words}
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

    local -a words=(${(z)LBUFFER})
    local last_word=${words[-1]}

    if [[ "$last_word" == '/tmp/' ]] ; then
        words[-1]='/ws/'
        LBUFFER=${(j: :)words}
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

# XXX can I find a way to apply highlighting to these? maybe cat with ANSI escape sequences + a zle reset-prmopt?
function _zsh-tips() {
zle -M "$(cat <<EOF
(.)       regular files only
(/)       directories only
(@)       symlinks only

*(.m-30)      matches regular files modified within the last 30 days
*(om[1])      matches the most recently modified file
*(.om[1,20])  matches the 20 most recently modified files
*.epub(m-1)   matches .epub files modified within the last day
*(.oc)        regular files, ordered by ctime
*(.OL)        regular files, ordered by size (descending)
*.pdf(m-11)   .pdf files modified within the last 11 days
*.json(mh-4)  .json files modified within the last 4 hours
*.tid(mm-5)   .tid files modified within the last 5 minutes
*(L0)         empty files
*.png(L0)     empty .png files

~/.zsh-scripts/Functions/**(.:t)  the basenames of all regular files under ~/.zsh-scripts/Functions

(NOTE: be careful about using (o) and (O) with ls, since ls orders its args!
EOF
)"
}

zle -N fat_finger_bang4_expand _fat_finger_bang4_expand
zle -N commmon_replacements _common_replacements
zle -N slash_show_relative_destination _slash_show_relative_destination
zle -N remove_magic_keys_and_search_backward _remove_magic_keys_and_search_backward
zle -N remove_magic_keys_and_search_forward _remove_magic_keys_and_search_forward
zle -N zsh-tips _zsh-tips

bindkey -M custom '^I' fat_finger_bang4_expand
bindkey -M custom ' ' commmon_replacements
bindkey -M custom '^[[11~' run-help
bindkey -M custom '^[[12~' zsh-tips
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

function _complete_files_wrapper() {
    _main_complete _files
}
zle -C complete-files .complete-word _complete_files_wrapper
bindkey -M custom '^X^F' complete-files

if which fzf &>/dev/null ; then
    __fzfcmd() {
      [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
        echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
    }
    fzf-history-widget() {
      local selected num
      setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
      selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
        FZF_DEFAULT_OPTS="--exact --height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --scheme=history --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
      local ret=$?
      if [ -n "$selected" ]; then
        num=$selected[1]
        if [ -n "$num" ]; then
          zle vi-fetch-history -n $num
        fi
      fi
      zle reset-prompt
      return $ret
    }
    zle     -N   fzf-history-widget
    bindkey -M vicmd '/' fzf-history-widget
fi
