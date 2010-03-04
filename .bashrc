# Exports ###################################################################

export LC_ALL=""
export LC_COLLATE="sv_SE.UTF-8"
export LC_CTYPE="sv_SE.UTF-8"
export LC_MONETARY="sv_SE.UTF-8"
export LC_NUMERIC="sv_SE.UTF-8"
export LC_TIME="sv_SE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LANG="sv_SE.UTF-8"

export EDITOR=vi
export PAGER=less
export DISPLAY=:0.0

# Paths #####################################################################

for path in "/usr/local/bin" \
            "/opt/local/bin" \
            "$HOME/bin" \
            "$HOME/local/bin";
do
    if [ -d $path ]; then
        PATH="$path:$PATH"
    fi
done

export PATH

# Bash history ##############################################################

export HISTCONTROL=erasedups
export HISTSIZE=10000
unset HISTFILESIZE
export HISTIGNORE="ls:exit"

shopt -s histappend
shopt -s cmdhist

# Whenever displaying the prompt, write the previous line to disk.
export PROMPT_COMMAND='history -a'

# Bash completion ###########################################################

for file in "/opt/local/etc/bash_completion" \
            "/opt/local/etc/bash_completion.d/git" \
            "/usr/local/etc/bash_completion" \
            "/etc/bash_completion";
do
    if [ -f $file ]; then
        source $file
    fi
done

# Override as Bash Completion does not honor 'set expand-tilde'.
_expand() { return 0; }

# Virtualenv and pip ########################################################

export PYTHONPATH="" # Disable to work nicely with pip.
export PIP_VIRTUALENV_BASE=$HOME/.virtualenvs
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

# Load a virtualenv
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
    # TODO: Give choice between multiple versions of Python?
    cd `echo "$PIP_VIRTUALENV_BASE/$VENV_NAME/lib/python*/site-packages"`
}

# Create a new virtual environment in $PIP_VIRTUALENV_BASE
mkvenv() {
    if [ -z $1 ] ; then
        echo "Usage: mkenv <name>"
        return 1
    fi
    local full_path="$PIP_VIRTUALENV_BASE/$1"
    if [ -d $full_path ]; then
        echo "A virtual environment by that name already exists."
        return 1
    fi
    virtualenv --no-site-packages $full_path
    return 0
}

complete -o default -o nospace -W '$(ls $PIP_VIRTUALENV_BASE)' loadenv cdenvsp

# Aliases ###################################################################

alias myip="ifconfig | grep '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | \
            grep -v '127.0.0.1' | awk '{print \$2}'"
alias ls="ls -G"
alias vi=vim
alias tmux="tmux -u"
alias port="sudo port"

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

# Remove all .pyc and .pyo files in tree
alias cleanpy="find . -name '*.py[oc]' -delete"

# Misc ######################################################################

shopt -s checkwinsize

# Prompt ####################################################################

PS1='[\u@\h]\W% '

# Local Configs #############################################################

load_host_bashrc() {
    local host_bits=`hostname`
    local hostname=${host_bits%%.*}
    if [ -e "$HOME/.bashrc.$hostname" ]; then
        source "$HOME/.bashrc.$hostname"
    fi
}
load_host_bashrc

if [ -e "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi
