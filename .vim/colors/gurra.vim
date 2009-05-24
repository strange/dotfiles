set background=dark
hi clear

hi Normal guifg=#FFFFFF guibg=#000000 gui=none
hi Statement guifg=#5d6065 gui=none
hi Identifier guifg=#bbbaab gui=none
hi Title guifg=salmon
hi String guifg=#818f71 gui=none
hi Comment guifg=#777777 gui=none

hi Type guifg=#999999 gui=none
hi Number guifg=#97806e gui=none
hi PreProc guifg=#DDDDDD gui=none

hi NonText guifg=#111111 gui=none

hi VertSplit guibg=#222222 guifg=#222222 gui=none
hi StatusLine guibg=#222222 guifg=#ffffff gui=none
hi StatusLineNC guibg=#222222 guifg=#555555 gui=none
hi CursorLine guibg=#090909
hi Visual gui=bold guifg=black guibg=#C0FFC0
hi LineNr guibg=#111111 guifg=#3d464c

hi Pmenu guibg=#222222 guifg=#EEEEEE 
hi PmenuSel guibg=#777777 guifg=#222222 

hi TODO guifg=#adac4f guibg=#000000

" Python
hi pythonArguments guifg=#74787d
hi pythonOps guifg=#8f815b
hi link pythonBuiltinFunc Identifier

" HTML
hi HtmlLink term=none cterm=underline ctermfg=9 gui=none guifg=#80a0ff
hi link HtmlTag HtmlTagName
hi link HtmlEndTag HtmlTag
hi link HtmlArg HtmlTag

" Django
hi clear djangoTagBlock
hi link djangoTagBlock Identifier
hi djangoVarBlock guifg=#7980a5
hi link djangoInternals Identifier

