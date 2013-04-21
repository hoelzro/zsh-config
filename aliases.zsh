alias ack="~/bin/ack"
alias cdblank="cdrecord --verbose dev=/dev/sr0 blank=fast"
alias cdburn="cdrecord --verbose --eject dev=/dev/sr0 driveropts=burnfree"
alias clyde='clyde --color'
alias cs='perl script/*_server.pl'
alias dvdblank="cdrecord --verbose dev=/dev/sr0 blank=fast"
alias dvdburn="cdrecord --verbose --eject dev=/dev/sr0"
alias grep="grep --colour=auto"
alias history="history -t '%F %T'"
alias jbos=jobs
alias less="less -RM"
alias ls="ls $__LS_FLAGS"
alias myrip="rip -c -f \"%A - %S\" -O -n -T"
alias notify-rob="xmpp-notify.pl -c ~/.notifyrob.yaml"
alias perldoc="LANG=en_US perldoc"
alias xmltidy='tidy -xml -i 2>/dev/null'
alias tree='tree -C'

alias gd='git diff'
alias gf='git fetch'
alias gff='git ff'
alias ga='git add'
alias gap='git add -p'
alias gc='git commit'
alias gcv='git commit -v'
alias gs='git status'
alias gsh='git show'
alias gt=tig

alias hd='hg diff'
alias hp='hg pull'
alias hr='hg record'
alias hs='hg status'
alias ht='hg tip'

if echo "$TERM" | grep -q -P '.*-256color' ; then
    alias tmux='tmux -2'
fi
