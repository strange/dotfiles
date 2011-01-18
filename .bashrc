# Exports ###################################################################

export EDITOR=vim
export PAGER=less
export DISPLAY=:0.0

# Paths #####################################################################

export PATH="/usr/local/sbin:/usr/local/bin:$HOME/bin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

# Bash history ##############################################################

export HISTCONTROL=erasedups
export HISTIGNORE="ls:exit"
export HISTSIZE=10000
unset HISTFILESIZE

shopt -s histappend
shopt -s cmdhist

# Whenever displaying the prompt, write the previous line to disk.
export PROMPT_COMMAND='history -a'

# Bash completion ###########################################################

for file in "/usr/local/etc/bash_completion" \
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

# Local Config ##############################################################

if [ -e "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi
