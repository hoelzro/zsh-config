setopt auto_cd
setopt auto_pushd
setopt pushd_silent
setopt always_to_end
setopt bash_auto_list # also sets list_ambiguous
setopt complete_in_word
setopt extendedglob
unsetopt hup
setopt list_rows_first
setopt list_types
setopt case_glob
setopt case_match
unsetopt nomatch
if zmodload | grep -q pcre ; then
    setopt rematch_pcre
fi
setopt unset
setopt append_history
setopt bang_hist # is this what I want? csh-style?
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt aliases # see if I like this
unsetopt clobber
set correct
set interactive_comments
# XXX expand glob?
set c_bases
set octal_zeroes
set bsd_echo
