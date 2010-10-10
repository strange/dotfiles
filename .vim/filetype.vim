if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.js set filetype=javascript
    au! BufRead,BufNewFile *.html set filetype=html
    au! BufRead,BufNewFile *.rst set filetype=rest
    au! BufRead,BufNewFile *.txt set filetype=rest
    au! BufRead,BufNewFile *.as set filetype=actionscript
    au! BufRead,BufNewFile *.xul set filetype=xml
augroup END
