if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.as setf actionscript
    au! BufRead,BufNewFile *.css setf css
    au! BufRead,BufNewFile *.erl setf erlang
    au! BufRead,BufNewFile *.html setf html
    au! BufRead,BufNewFile *.js setf javascript
    au! BufRead,BufNewFile *.py setf python
    au! BufRead,BufNewFile *.rst setf rest
    au! BufRead,BufNewFile *.txt setf rest
    au! BufRead,BufNewFile *.vim setf vim
    au! BufRead,BufNewFile *.xul setf xml

    au! BufRead,BufNewFile .muttrc* setf muttrc

    au! BufNewFile,BufRead *.git/COMMIT_EDITMSG setf gitcommit
    au! BufNewFile,BufRead *.git/config,.gitconfig setf gitconfig
    au! BufNewFile,BufRead git-rebase-todo setf gitrebase

    au! BufNewFile,BufRead .mailcap,mailcapsetf mailcap
    au! BufNewFile,BufRead snd.\d\+,.letter,.letter.\d\+,.followup,.article,.article.\d\+,pico.\d\+,mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\{6\},ae\d\+.txt,/tmp/SLRN[0-9A-Z.]\+,*.eml setf mail

    au! BufNewFile,BufRead crontab,crontab.*,/etc/cron.d/*ENDcall setf crontab

    au! BufNewFile,BufRead *.Z,*.gz,*.bz2,*.zip,*.tgz set filetype=
augroup END
