export DISPLAY=:0.0

export LC_ALL=""
export LANG="sv_SE.UTF-8"
export LC_COLLATE="sv_SE.UTF-8"
export LC_CTYPE="sv_SE.UTF-8"
export LC_MESSAGES="sv_SE.UTF-8"
export LC_MONETARY="sv_SE.UTF-8"
export LC_NUMERIC="sv_SE.UTF-8"
export LC_TIME="sv_SE.UTF-8"
export LC_MESSAGES="en_US"

export PYTHONPATH="$PYTHONPATH::$HOME/site-packages:."
export PATH="/opt/local/bin:/opt/local/sbin:$PATH:$HOME/bin"
export MANPATH=/opt/local/share/man:$MANPATH

export EDITOR=vim

PS1='[\u@\h \W$(__git_ps1 ":%s")]\$ '

# Bash history

export HISTCONTROL=erasedups
export HISTSIZE=10000

# Make Bash append rather than overwrite the history on
# disk
shopt -s histappend

# Whenever displaying the prompt, write the previous line
# to disk.
PROMPT_COMMAND='history -a'

# Bash completion

source /opt/local/etc/bash_completion
source /opt/local/etc/bash_completion.d/git
_expand() { return 0; }

# Aliases

alias ls="ls -G"

alias myip="ifconfig | grep 192 | awk '{print \$2}'"

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
