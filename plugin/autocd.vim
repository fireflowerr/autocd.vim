" ####################################################################################################
" Vim autocd plugin
" ####################################################################################################

if !exists('g:autocd#nerdtree_close')
  let g:autocd#nerdtree_close = 0
endif

fun! Autocd()
  let l:open = g:NERDTree.IsOpen()
  call autocd_main#autocd()

  if exists('g:loaded_nerd_tree') && g:loaded_nerd_tree == 1 && 
\       exists('g:autocd#sync_nerdtree') && g:autocd#sync_nerdtree == 1 

    execute('NERDTreeCWD')
    if !l:open
      execute('NERDTreeClose')
    endif

  endif
endfun

command! Autocd call Autocd()
