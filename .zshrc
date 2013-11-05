[[ -z "$PS1" ]] && return

autoload -U colors
# autoload -Uz vcs_info
autoload -U compinit -C -D

colors

# settings

setopt prompt_subst
setopt rm_star_wait
setopt auto_cd
setopt no_beep
setopt vi
setopt no_prompt_sp
setopt correct
setopt nolistambiguous

zstyle ':completion:*' completer _complete
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*' accept-exact '*(N)'

compinit

bindkey '^[[Z' reverse-menu-complete

# history 

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.history

setopt append_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_verify

autoload -U history-search-end 

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey '^R' history-incremental-search-backward
bindkey '^?'  backward-delete-char

# env

export EDITOR="vim"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_CTYPE=C

# virtualenv and pip

export PYTHONPATH=""
export PIP_VIRTUALENV_BASE=$HOME/.virtualenvs
export PIP_REQUIRE_VIRTUALENV=false
export PIP_RESPECT_VIRTUALENV=true

loadenv() {
    if [ -f env/bin/activate ] ; then 
        source env/bin/activate
    else
        local venv_name=`[ -n "$1" ] && echo "$1" || echo ${PWD##*/}`
        source "$PIP_VIRTUALENV_BASE/$venv_name/bin/activate"
    fi
}

# aliases

alias ssh='TERM=xterm ssh'

alias sz="source $HOME/.zshrc"
alias myip="ifconfig | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
            grep -v '127.0.0.1' | awk '{print \$2}' && curl my-ip.heroku.com"
alias rm="rm -i"
alias mv="mv -i"
alias ls="ls -G"
alias cleanpy="find . -name '*.py[oc]' -delete"

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

# alias djrun="python ./*/manage.py runserver"
# alias djsync="python ./*/manage.py syncdb"
# alias djdb="python ./*/manage.py dbshell"
# alias djshell="python ./*/manage.py shell"
# alias djsql="python ./*/manage.py sql"

# functions

tmux-django() {
    local dir=$HOME/src/django/$1
    if [ -d $dir ]; then
        cd $dir
        tmux send-keys "cd $dir && vim" C-m
        tmux split-window -h
        tmux send-keys "cd $dir && loadenv && djrun" C-m
        tmux split-window -v
        tmux send-keys "cd $dir" C-m
        tmux select-pane -L
        tmux rename-window $1
    else
        echo "No go man!"
    fi
}

_tmux_django_complete() {
    local completions="$(ls $HOME/src/django)"
    reply=("${(ps:\n:)completions}")
}

compctl -K _tmux_django_complete tmux-django

# prompt

# zstyle ':vcs_info:git*' formats ":%u%b%m"
# zstyle ':vcs_info:*' enable git

# precmd() { vcs_info }
# PROMPT='%c${vcs_info_msg_0_}%{$fg[red]%}%#%{$reset_color%} '
PROMPT='%c%{$fg[red]%}%#%{$reset_color%} '

# source local config

function {
    local localrc="$HOME/.zshrc.$(hostname | awk -F . '{print $1}')"
    [[ -r "$localrc" ]] && source "$localrc"
}
