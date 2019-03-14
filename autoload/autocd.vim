" ####################################################################################################
" Vim autocd plugin
" ####################################################################################################

scriptencoding utf-8

fun! autocd#load()
  let s:cwd = ''
  let g:autocd#loaded = 1
endfun

" nt_isopen, nt_isloaded, dir
fun! autocd#autocd(dir)
  call s:clear_log()

  if !exists('g:autocd#loaded') || !g:autocd#loaded
    let s:log = s:log . 'plugin not initialized.' . "\n"
    return 1
  endif

  if !s:buf_listed()
    let s:log = s:log . 'unlisted buff, no action required.' . "\n"
    return 0
  endif

  for ignore in g:autocd#ignore
    if a:dir =~# ignore
      let s:log = s:log . 'buffer ignored' . "\n"
      return 0
    endif
  endfor

  let l:newcwd = getcwd()
  if s:cwd =~# '^' . l:newcwd . '$'
    let s:log = s:log . 'directory unchanged, no action required.' . "\n"
    return 0
  endif
  let s:cwd = l:newcwd

  let l:target_dir = s:search_markers(a:dir)

  let s:log = s:log . 'path: ' . expand(a:dir) . "\n" .
  \     'target_dir: ' . l:target_dir . "\n"

  if !l:target_dir 
    call s:switch_dir(l:target_dir)
    if s:nts
      call s:NERDTree_sync() 

    endif 
  endif
  
  if g:autocd#generate_log
    execute('redir >> ' . g:autocd#log_path . "/autocd.log | silent echo s:log | redir END ")
    let s:log = ''
  endif
endfun

" Abstracted search for autocd. 
fun! s:search_markers(dir)
  let l:target_dir = s:get_path_val(a:dir)
  let s:log = s:log . 'get_path_val(): ' . l:target_dir . "\n"

  if l:target_dir && g:autocd#markers_default 
    let l:target_dir = g:autocd#makers_get_default()
    let s:log = s:log . 'get_default(): ' . l:target_dir . "\n" 
  endif

  return l:target_dir
endfun

" Returns the direcotry of a path cd search
fun! s:get_path_val(dir)
  
  let l:skip = 0
  let l:num_keys = len(g:autocd#markers)

  while l:skip < l:num_keys

    let l:dir_key = s:get_path_key(a:dir, l:skip)
    let s:log = s:log . 'dir_key: ' . l:dir_key . "\n"

    if l:dir_key 
      let l:dir = 1
    else
      let l:dir = s:search_marker_set(a:dir, g:autocd#markers[l:dir_key])
    endif
      
    if !l:dir
      return l:dir
    endif
    let l:skip += 1
  endwhile

  return 1
endfun

" Returns the first matching subpath of the dir and the g:autocd#markers list
fun! s:get_path_key(dir, skip)
  let l:sorted = sort(keys(g:autocd#markers), 's:path_comparator')
  let l:skip_cnt = 0

  for path in l:sorted
    if l:skip_cnt < a:skip
      let l:skip_cnt += 1
      continue
    endif
    if fnameescape(a:dir) =~# glob2regpat(path)
      return path
    endif
  endfor

  return 1
endfun

fun! s:path_comparator(s1, s2)
  let l:v1 = strlen(substitute(a:s1, "[^\/]", '', 'g'))
  let l:v2 = strlen(substitute(a:s2, "[^\/]", '', 'g'))
  let l:ret = l:v1 == l:v2 ? 0 : l:v1 < l:v2 ? 1 : -1
  let s:log = s:log . 'path_comparator(' . a:s1 . ', ' . a:s2 . '): ' . l:ret . "\n"
  return l:ret
endfun

" Search a given directory upwards and see if contains a file listed in the provided list
fun! s:search_marker_set(dir, markers)
  let l:dir = a:dir
  let l:depthCounter = g:autocd#max_depth
  let l:fmod = ':h'
  while l:dir !~# '^.$' && l:depthCounter != 0

    for marker in a:markers
      if(!empty(glob(l:dir . '/' . marker, 1)))
        return l:dir
      endif
    endfor

    let l:dir = fnamemodify(l:dir, l:fmod) 
    let l:depthCounter -= 1
  endwhile

  return 1
endfun

" Switch dir
fun! s:switch_dir(dir) 
  if tabpagenr('$') == 1 || !g:autocd#tab_isolation
    execute('cd ' . a:dir)
  else
    execute('lcd ' . a:dir)
  endif
endfun

" Sync NERDTree with directory change from this plugin's invocation
fun! s:NERDTree_sync()
  let l:winnr = winnr()
  let l:newcwd = getcwd()
  let s:log = s:log . 'oldcwd: ' . s:cwd . "\nnewcwd: " . l:newcwd . "\n"
  if s:cwd !~# '^' . l:newcwd . '$'
    let s:cwd = l:newcwd
    let l:nt_open = g:NERDTree.IsOpen()

    execute('NERDTreeCWD')
    if !l:nt_open
      execute('NERDTreeClose')
    endif

  endif

 execute(l:winnr . 'wincmd w') 
endfun

" Enable NERDTree sync
fun! autocd#nts_enable()
  call s:clear_log()
  if exists('g:NERDTree')
    let s:cwd = ''  
    let s:nts = 1
    call s:NERDTree_sync()
  else
    call autocd#nts_disable()
  endif
endfun

" Disable NERDTree sync
fun! autocd#nts_disable()
  let s:nts = 0
endfun

fun! s:clear_log()
  let s:log = ''
endfun

fun! s:buf_listed()
  let bufnr = bufnr('')
  let l:buf_list = split(execute('ls!'), "\n", 0)
  let l:i = 0

  for buf in l:buf_list
    let l:buf_list[i] = substitute(l:buf_list[i], '^\S*\s*\(\S*\).*', '\1', 1)
    let l:i += 1
  endfor

  for buf in l:buf_list
    if buf =~# '^' . bufnr . '\D*'
      if buf =~ 'u'
        return 0
      endif
    endif
  endfor

  return 1
endfun
