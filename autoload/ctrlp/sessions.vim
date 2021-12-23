if exists('g:loaded_ctrlp_sessions') && g:loaded_ctrlp_sessions
  finish
endif
let g:loaded_ctrlp_sessions = 1
let s:save_cpo = &cpo
set cpo&vim

let s:sessions_var = {
      \   'init':   'ctrlp#sessions#init()',
      \   'accept': 'ctrlp#sessions#accept',
      \   'lname':  'sessions',
      \   'sname':  'sessions',
      \   'type':   'path',
      \   'nolim':  1
      \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:sessions_var)
else
  let g:ctrlp_ext_vars = [s:sessions_var]
endif

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#sessions#id() abort
  return s:id
endfunction

function! ctrlp#sessions#init() abort
  let l:wildignore = &wildignore
  let &wildignore = ''

  let l:sessions = split(globpath(s:sessions_dir(), '*.vim'))
  let l:result   = map(l:sessions, "fnamemodify(expand(v:val), ':t:r')")

  let &wildignore = l:wildignore

  return l:result
endfunction

function! ctrlp#sessions#accept(mode, str) abort
  call ctrlp#exit()

  execute('source ' . s:make_session_path(a:str))
endfunction

function! ctrlp#sessions#save_session(...) abort
  if a:0 >= 1
    let l:name = a:1
  else
    let l:name = input('Session name: ')
  endif

  redraw
  echo ''

  if l:name == ''
    return
  endif

  let l:dir = s:sessions_dir()
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif

  execute('mksession! ' . s:make_session_path(l:name))
endfunction

function! s:sessions_dir()
  return expand(g:ctrlp_sessions_dir)
endfunction

function! s:make_session_path(name)
  return s:sessions_dir() . '/' . a:name . '.vim'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
