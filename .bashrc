[[ $- != *i* ]] && return

# Exports ###################################################################

export EDITOR=vim
export PAGER=less
export DISPLAY=:0.0

# Paths #####################################################################

export PATH="$HOME/bin:$HOME/.cabal/bin:/usr/local/sbin:/usr/local/bin:$PATH:/root/.gem/ruby/2.2.0/bin"
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
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

# shortcut to load virtual environment with same name as cwd
loadenv() {
    if [ -f env/bin/activate ] ; then 
        source env/bin/activate
    else
        local venv_name=`[ -n "$1" ] && echo "$1" || echo ${PWD##*/}`
        source "$PIP_VIRTUALENV_BASE/$venv_name/bin/activate"
    fi
}

# Fabric ####################################################################

complete -o default -o nospace -W '$(fab --shortlist)' fab

# Aliases ###################################################################

alias myip="ip addr | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
            grep -v '127.0.0.1' | awk '{print \$2}' && curl my-ip.heroku.com"
alias ls="ls --color"
alias vi="vim"
alias jnc="jnc --nox"
alias curl="curl --user-agent \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20100101 Firefox/17.0\""

# Some Django convenience aliases
alias djmanage='python $(find . -maxdepth 2 -name manage.py -print -quit)'
alias djrun='djmanage runserver'
alias djunicorn='djmanage run_gunicorn'
alias djsync='djmanage syncdb'
alias djshell='djmanage shell'
alias djdb='djmanage dbshell'
alias djsql='djmanage sql'
alias djtest='djmanage test'
alias djvalidate='djmanage validate'
alias djmakemessages='djmanage makemessages'
alias djcompilemessages='djmanage compilemessages'

# Remove all .pyc and .pyo files in tree
alias cleanpy="find . -name '*.py[oc]' -delete"

alias erl="rlwrap -a erl"

# Misc ######################################################################

shopt -s checkwinsize

# Prompt ####################################################################

if [ $(command -v __git_ps1) ]; then
    PS1='[\u@\h]\W$(__git_ps1 ":%s")% '
else
    PS1='[\u@\h]\W\[\033[0;31m\]\$\[\033[0m\] '
fi

# Local Config ##############################################################

if [ -e "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi

export PERL_LOCAL_LIB_ROOT="/home/gs/perl5:$PERL_LOCAL_LIB_ROOT";
export PERL_MB_OPT="--install_base "/home/gs/perl5"";
export PERL_MM_OPT="INSTALL_BASE=/home/gs/perl5";
export PERL5LIB="/home/gs/perl5/lib/perl5:$PERL5LIB";
export PATH="/home/gs/perl5/bin:/home/gs/.gem/ruby/2.1.0/bin:$PATH";
