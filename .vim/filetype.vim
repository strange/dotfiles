if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.html set filetype=htmldjango
    au! BufRead,BufNewFile models.py set filetype=djangomodels.python
    au! BufRead,BufNewFile *.txt set filetype=rest
    au! BufRead,BufNewFile *.as set filetype=actionscript
    au! BufRead,BufNewFile *.xul set filetype=xml
augroup END
