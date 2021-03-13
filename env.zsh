export BROWSER="open-browser"
export DBIC_TRACE_PROFILE=console
export EDITOR=vim
export EMAIL='rob@hoelz.ro'
export FIGNORE=.o
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GIT_AUTHOR_NAME='Rob Hoelz'
export GIT_AUTHOR_EMAIL=$EMAIL
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
export GOPATH="$HOME/.local/share/go-deps:$HOME/projects/gocode"
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export KEYTIMEOUT=1
export LC_TIME=POSIX
export LUA_HISTORY=~/.luahist
export LUA_HISTSIZE=100
export LUA_INIT="@$HOME/.luarc"
export MANOPT="--no-hyphenation"
export MANPAGER=man-pager
export MANPATH=$MANPATH:/usr/share/man
export MANSECT='1:l:8:3:0:2:5:4:9:6:7:n'
export MPD_HOST=127.0.0.1
export MYSQL_PS1="mysql [\U \d]:\c> "
export PAGER="less -RM"
export PATH=$PATH:~/bin/:~/.luarocks/bin
export PERLDOC_PAGER=man-pager
export PERL_CPANM_OPT="--mirror file://$HOME/minicpan --mirror https://cpan.mirrors.tds.net/ --mirror https://cpan.cpantesters.org/ --prompt"
export PGUSER=postgres
export REPORTTIME=5
export SAVEHIST=1000000
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WINEARCH=win32
export WORKON=$HOME/.virtualenvs/
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

unset MAIL

if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ] ; then
    unlink "$HOME/.ssh/agent_sock" 2>/dev/null
    ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"
fi
