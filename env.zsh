export BROWSER="open-browser"
export DBIC_TRACE_PROFILE=console
export EDITOR=vim
export EMAIL='rob@hoelz.ro'
export FIGNORE=.o
export GIT_AUTHOR_NAME='Rob Hoelz'
export GIT_AUTHOR_EMAIL=$EMAIL
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
export GOPATH="$HOME/.local/share/go-deps:$HOME/projects/gocode"
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export LUA_HISTORY=~/.luahist
export LUA_HISTSIZE=100
export LUA_INIT="@$HOME/.luarc"
export MANPAGER=man-pager
export MANPATH=$MANPATH:/usr/share/man
export MPD_HOST=127.0.0.1
export MYSQL_PS1="mysql [\U \d]:\c> "
export PAGER="less -RM"
export PATH=$PATH:~/bin/:~/.luarocks/bin
export PERLDOC_PAGER=man-pager
export PERL_CPANM_OPT="--mirror file://$HOME/minicpan --mirror http://cpan.mirror.triple-it.nl/ --mirror http://cpan.cpantesters.org/ --prompt"
export PGUSER=postgres
export REPORTTIME=5
export SAVEHIST=25000
export WINEARCH=win32

unset MAIL

if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ] ; then
    unlink "$HOME/.ssh/agent_sock" 2>/dev/null
    ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"
fi
