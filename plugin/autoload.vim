" ####################################################################################################
" Vim autocd plugin
" ####################################################################################################

if !exists('g:autocd#nerdtree_close')
  let g:autocd#nerdtree_close = 0
endif

command! Autocd call autocd_main#autocd()
