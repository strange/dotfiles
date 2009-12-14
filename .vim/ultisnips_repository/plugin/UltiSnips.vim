" File: UltiSnips.vim
" Author: Holger Rapp <SirVer@gmx.de>
" Description: The Ultimate Snippets solution for Vim
" Last Modified: July 21, 2009
"
" Testing Info: {{{
"   See directions at the top of the test.py script located one 
"   directory above this file.
" }}}

if exists('did_UltiSnips_vim') || &cp || version < 700 || !has("python")
    finish
endif

" Global Variables {{{

" The trigger used to expand a snippet.
" NOTE: expansion and forward jumping can, but needn't be the same trigger
if !exists("g:UltiSnipsExpandTrigger")
 let g:UltiSnipsExpandTrigger = "<tab>"
endif

" The trigger used to display all triggers that could possible 
" match in the current position.
if !exists("g:UltiSnipsListSnippets")
 let g:UltiSnipsListSnippets = "<c-tab>"
endif

" The trigger used to jump forward to the next placeholder. 
" NOTE: expansion and forward jumping can, but needn't be the same trigger
if !exists("g:UltiSnipsJumpForwardTrigger")
 let g:UltiSnipsJumpForwardTrigger = "<c-j>"
endif

" The trigger to jump backward inside a snippet
if !exists("g:UltiSnipsJumpBackwardTrigger")
 let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
endif

" }}}

"" FUNCTIONS {{{
function! UltiSnips_ExpandSnippet()
 py UltiSnips_Manager.expand()
 return ""
endfunction

function! UltiSnips_ExpandSnippetOrJump()
 py UltiSnips_Manager.expand_or_jump()
 return ""
endfunction

function! UltiSnips_ListSnippets()
 py UltiSnips_Manager.list_snippets()
 return ""
endfunction

function! UltiSnips_JumpBackwards()
 py UltiSnips_Manager.jump_backwards()
 return ""
endfunction

function! UltiSnips_JumpForwards()
 py UltiSnips_Manager.jump_forwards()
 return ""
endfunction

function! UltiSnips_MapKeys()
   " Map the keys correctly
   if g:UltiSnipsExpandTrigger == g:UltiSnipsJumpForwardTrigger
      exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=UltiSnips_ExpandSnippetOrJump()<cr>"
      exec "snoremap <silent> " . g:UltiSnipsExpandTrigger . " <Esc>:call UltiSnips_ExpandSnippetOrJump()<cr>"
   else
      exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=UltiSnips_ExpandSnippet()<cr>"
      exec "snoremap <silent> " . g:UltiSnipsExpandTrigger . " <Esc>:call UltiSnips_ExpandSnippet()<cr>"
      exec "inoremap <silent> " . g:UltiSnipsJumpForwardTrigger  . " <C-R>=UltiSnips_JumpForwards()<cr>"
      exec "snoremap <silent> " . g:UltiSnipsJumpForwardTrigger  . " <Esc>:call UltiSnips_JumpForwards()<cr>"
   endif
   exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=UltiSnips_JumpBackwards()<cr>"
   exec "snoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <Esc>:call UltiSnips_JumpBackwards()<cr>"
   exec "inoremap <silent> " . g:UltiSnipsListSnippets . " <C-R>=UltiSnips_ListSnippets()<cr>"
   exec "snoremap <silent> " . g:UltiSnipsListSnippets . " <Esc>:call UltiSnips_ListSnippets()<cr>"

   " Do not remap this.
   snoremap <silent> <BS> <Esc>:py  UltiSnips_Manager.backspace_while_selected()<cr>
endf
" }}}

"" STARTUP CODE {{{

" Expand our path
python << EOF
import vim, os, sys

for p in vim.eval("&runtimepath").split(','):
   dname = p + os.path.sep + "plugin"
   if os.path.exists(dname + os.path.sep + "UltiSnips"):
      if dname not in sys.path:
         sys.path.append(dname)
      break

from UltiSnips import UltiSnips_Manager
UltiSnips_Manager.expand_trigger = vim.eval("g:UltiSnipsExpandTrigger")
UltiSnips_Manager.forward_trigger = vim.eval("g:UltiSnipsJumpForwardTrigger")
UltiSnips_Manager.backward_trigger = vim.eval("g:UltiSnipsJumpBackwardTrigger")
EOF

au CursorMovedI * py UltiSnips_Manager.cursor_moved()
au InsertEnter * py UltiSnips_Manager.entered_insert_mode()

call UltiSnips_MapKeys()
  
let did_UltiSnips_vim=1

" }}}
