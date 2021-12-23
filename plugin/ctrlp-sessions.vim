if exists('g:loaded_sessions')
  finish
endif
let g:loaded_sessions = 1
let s:save_cpo = &cpo
set cpo&vim

let g:ctrlp_sessions_dir = get(g:, 'ctrlp_sessions_dir', '~/.vim_sessions')
 
command!          CtrlPSessions call ctrlp#init(ctrlp#sessions#id())
command! -nargs=? Session       call ctrlp#sessions#save_session(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

