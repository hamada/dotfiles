if exists("g:loaded_friendly_grep")
  finish
endif
let g:loaded_friendly_grep = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 FriendlyGrep call friendly_grep#FriendlyGrep()

let &cpo = s:save_cpo
unlet s:save_cpo
