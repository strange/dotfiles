" These are the mappings for snipMate.vim. Putting it here ensures that it
" will be mapped after other plugins such as supertab.vim.
if !exists('loaded_snips') || exists('s:did_snips_mappings')
	finish
endif
let s:did_snips_mappings = 1

" EDIT: Added proxies and new bindings.

function TriggerProxy()
	if exists('g:snipPos') | return snipMate#jumpTabStop(0) | endif
	return "\<tab>"
endfunction

fun! BackwardsProxy()
	if exists('g:snipPos') | return snipMate#jumpTabStop(1) | endif
	return "\<s-tab>"
endf

ino <silent> <tab> <c-r>=TriggerProxy()<cr>
snor <silent> <tab> <esc>i<right><c-r>=TriggerProxy()<cr>
ino <silent> <s-tab> <c-r>=BackwardsProxy()<cr>
snor <silent> <s-tab> <esc>i<right><c-r>=BackwardsProxy()<cr>

"ino <silent> <tab> <c-r>=TriggerSnippet()<cr>
"snor <silent> <tab> <esc>i<right><c-r>=TriggerSnippet()<cr>
"ino <silent> <s-tab> <c-r>=BackwardsSnippet()<cr>
"snor <silent> <s-tab> <esc>i<right><c-r>=BackwardsSnippet()<cr>
"ino <silent> <c-r><tab> <c-r>=ShowAvailableSnips()<cr>
" The default mappings for these are annoying & sometimes break snipMate.
" You can change them back if you want, I've put them here for convenience.
snor <bs> b<bs>
snor <right> <esc>a
snor <left> <esc>bi
snor ' b<bs>'
snor ` b<bs>`
snor % b<bs>%
snor U b<bs>U
snor ^ b<bs>^
snor \ b<bs>\
snor <c-x> b<bs><c-x>

" By default load snippets in snippets_dir
if empty(snippets_dir)
	finish
endif

call GetSnippets(snippets_dir, '_') " Get global snippets

au FileType * if &ft != 'help' | call GetSnippets(snippets_dir, &ft) | endif
" vim:noet:sw=4:ts=4:ft=vim
