if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au BufNewFile,BufRead *.Z,*.gz,*.bz2,*.zip,*.tgz set filetype=nofiletype

    au BufNewFile,BufRead *.as setf actionscript
    au BufNewFile,BufRead *.css setf css
    au BufNewFile,BufRead *.erl setf erlang
    au BufNewFile,BufRead *.html setf html
    au BufNewFile,BufRead *.js setf javascript
    au BufNewFile,BufRead *.py setf python
    au BufNewFile,BufRead *.rst,*.txt setf rest
    au BufNewFile,BufRead *.vim setf vim
    au BufNewFile,BufRead *.xul setf xml
    au BufNewFile,BufRead *.rb,*.gem ruby
    au BufNewFile,BufRead *.sh setf sh
    au BufNewFile,BufRead *.md,*.markdown setf markdown
    au BufNewFile,BufRead *.php setf php

    au BufNewFile,BufRead .muttrc* setf muttrc

    au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash_profile*,.bash_logout*,*.bash setf sh

    au BufNewFile,BufRead ssh_config,*/.ssh/config setf sshconfig
    au BufNewFile,BufRead sshd_config setf sshdconfig

    au BufNewFile,BufRead *.git/COMMIT_EDITMSG setf gitcommit
    au BufNewFile,BufRead *.git/config,.gitconfig setf gitconfig
    au BufNewFile,BufRead git-rebase-todo setf gitrebase

    au BufNewFile,BufRead .mailcap,mailcapsetf mailcap
    au BufNewFile,BufRead snd.\d\+,.letter,.letter.\d\+,.followup,.article,.article.\d\+,pico.\d\+,mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\{6\},ae\d\+.txt,/tmp/SLRN[0-9A-Z.]\+,*.eml setf mail

    au BufNewFile,BufRead crontab,crontab.*,/etc/cron.d/* setf crontab

    au BufNewFile,BufRead /etc/nginx/*.conf,/etc/nginx/sites-enabled/*,/etc/nginx/sites-available/* setf conf
    au BufNewFile,BufRead /etc/hosts setf conf

    au BufNewFile,BufRead *vimrc* setf vim
augroup END
