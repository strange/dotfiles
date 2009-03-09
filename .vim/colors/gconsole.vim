set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="gconsole"

hi Normal       ctermfg=lightgray ctermbg=none
hi NonText      ctermfg=darkgray  ctermbg=none

hi Statement    ctermfg=darkgray  ctermbg=none
hi Comment      ctermfg=darkgray  ctermbg=none
hi Constant     ctermfg=darkcyan  ctermbg=none
hi Identifier   ctermfg=cyan      ctermbg=none
hi Type         ctermfg=lightred  ctermbg=none
hi Special      ctermfg=blue      ctermbg=none
hi PreProc      ctermfg=lightgray ctermbg=none cterm=bold term=bold
hi Scrollbar    ctermfg=blue      ctermbg=none
hi Cursor       ctermfg=white     ctermbg=none
hi ErrorMsg     ctermfg=red       ctermbg=none cterm=bold term=bold
hi WarningMsg   ctermfg=yellow    ctermbg=none
hi Directory    ctermfg=cyan      ctermbg=none
hi Visual       ctermfg=cyan      ctermbg=black
hi Title        ctermfg=white     ctermbg=none

hi StatusLine   term=bold cterm=bold ctermfg=black ctermbg=white
hi StatusLineNC term=bold cterm=bold ctermfg=darkgray  ctermbg=white
hi LineNr       term=bold cterm=bold ctermfg=white ctermbg=none
hi VertSplit    ctermfg=white     ctermbg=white

hi PmenuSel     ctermbg=darkyellow    ctermfg=black
hi Pmenu        ctermbg=black  ctermfg=darkgray

" HTML
hi link HtmlTag HtmlTagName
hi link HtmlEndTag HtmlTag
hi link HtmlArg HtmlTag

" Django
hi clear djangoTagBlock
hi link djangoTagBlock Identifier
hi link djangoVarBlock Identifier
hi link djangoInternals Identifier
