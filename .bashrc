export DISPLAY=:0.0

export LC_ALL=""
export LANG="sv_SE.UTF-8"
export LC_COLLATE="sv_SE.UTF-8"
export LC_CTYPE="sv_SE.UTF-8"
export LC_MONETARY="sv_SE.UTF-8"
export LC_NUMERIC="sv_SE.UTF-8"
export LC_TIME="sv_SE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

export PYTHONPATH="" # Disable to work nicely with pip.
export PATH="$PATH:$HOME/bin"

export EDITOR=vim
export PAGER=less

export TERM=xterm-color

# Bash history
export HISTCONTROL=erasedups
export HISTSIZE=10000
# Make Bash append rather than overwrite the history on disk
shopt -s histappend
# Whenever displaying the prompt, write the previous line to disk.
PROMPT_COMMAND='history -a'

# Update lines and columns on resize.
shopt -s checkwinsize

# Bash completion
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ -f /opt/local/etc/bash_completion.d/git ]; then
    . /opt/local/etc/bash_completion.d/git
fi
#_expand() { return 0; }

# Virtualenv
export PIP_VIRTUALENV_BASE=$HOME/.virtualenvs

# Load a virtualenv.
loadenv() {
    local VENV_NAME=`[ -n "$1" ] && echo "$1" || echo ${PWD##*/}`
    local VENV_PATH="$PIP_VIRTUALENV_BASE/$VENV_NAME/bin/activate"
    if [ ! -e "$VENV_PATH" ]; then
        echo "Environment '$VENV_NAME' does not exist." 
        return 1
    fi
    source $VENV_PATH
}

# Change directory to site-packages directory of a virtualenv.
cdenvsp() {
    local VENV_NAME=`[ -n "$1" ] && echo "$1" || echo ${PWD##*/}`
    # TODO: Give choice between multiple versions og Python?
    cd `echo "$PIP_VIRTUALENV_BASE/$VENV_NAME/lib/python*/site-packages"`
}
complete -o default -o nospace -W '$(ls $PIP_VIRTUALENV_BASE)' loadenv cdenvsp

# Aliases
alias myip="ifconfig | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | \
            grep -v '127.0.0.1' | awk '{print \$2}'"

alias ls="ls -G"
alias vi=vim
alias tmux="tmux -u"

# Some Django convenience aliases
alias djrun='django-admin.py runserver --settings=${PWD##*/}.settings'
alias djsync='django-admin.py syncdb --settings=${PWD##*/}.settings'
alias djshell='django-admin.py shell --settings=${PWD##*/}.settings'
alias djdb='django-admin.py dbshell --settings=${PWD##*/}.settings'
alias djsql='django-admin.py sql --settings=${PWD##*/}.settings'
alias djtest='django-admin.py test --settings=${PWD##*/}.settings'
alias djvalidate='django-admin.py validate --settings=${PWD##*/}.settings'
alias djmakemessages='django-admin.py makemessages --settings=${PWD##*/}.settings'
alias djcompilemessages='django-admin.py compilemessages'

# Host-specific. Should probably source a .bashrc.local or something.
if [ $HOSTNAME == "gurraman.local" ]; then
    PS1='[\u@\h]\W$(__git_ps1 ":%s")\[\e[1;31m\]%\[\e[0m\] '
    export PATH="$PATH:/opt/local/bin:/opt/local/sbin"
    export MANPATH=$MANPATH:/opt/local/share/man
    alias weechat="weechat-curses"
    alias startpg="sudo -u postgres /opt/local/lib/postgresql83/bin/postgres -D /opt/local/var/db/postgresql83/defaultdb"
    alias lock="open -a ScreenSaverEngine"
else
    PS1='[\u@\h]\W% '
fi
