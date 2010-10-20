# Exports ###################################################################

export LC_ALL=""
export LC_COLLATE="sv_SE.UTF-8"
export LC_CTYPE="sv_SE.UTF-8"
export LC_MONETARY="sv_SE.UTF-8"
export LC_NUMERIC="sv_SE.UTF-8"
export LC_TIME="sv_SE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LANG="en_US.UTF-8"

export EDITOR=vim
export PAGER=less
export DISPLAY=:0.0

# Paths #####################################################################

export PATH="/usr/local/bin:/opt/local/bin:$HOME/bin:$PATH"
export MANPATH="/usr/local/man:/opt/local/man:$MANPATH"

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
            "/usr/local/etc/bash_completion.d" \
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
export PIP_REQUIRE_VIRTUALENV=false
export PIP_RESPECT_VIRTUALENV=true

# load virtualenvwrapper if it has been installed
loadvirtualenvwrapper() {
    local vwpath=`which virtualenvwrapper.sh`
    if [ -f $vwpath ]; then
        source $vwpath
        export WORKON_HOME=$PIP_VIRTUALENV_BASE
    fi
}
loadvirtualenvwrapper

# shortcut to load virtual environment with same name as cwd
loadenv() {
    local venv_name=`[ -n "$1" ] && echo "$1" || echo ${PWD##*/}`
    workon $venv_name
}
complete -o default -o nospace -W '$(ls $PIP_VIRTUALENV_BASE)' loadenv

# Fabric ####################################################################

complete -o default -o nospace -W '$(fab --shortlist)' fab

# Aliases ###################################################################

alias myip="ifconfig | grep '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | \
            grep -v '127.0.0.1' | awk '{print \$2}'"
alias ls="ls -G"
alias vi=vim
alias tmux="tmux -u"
alias port="sudo port"

# Some Django convenience aliases
alias djrun='django-admin.py runserver --settings=${PWD##*/}.settings'
alias djunicorn='django-admin.py run_gunicorn --settings=${PWD##*/}.settings'
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

if [ $(command -v __git_ps1) ]; then
    PS1='[\u@\h]\W$(__git_ps1 ":%s")% '
else
    PS1='[\u@\h]\W% '
fi

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
