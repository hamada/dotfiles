" friendlygrep.vim
" Maintainer:  Akira Hamada <drumcorps.enthusiast@gmail.com>
" Version:  0.1
" See doc/friendlygrep.txt for instructions and usage.

if exists("g:loaded_friendlygrep")
  finish
endif
let g:loaded_friendlygrep = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 FriendlyGrep call friendlygrep#FriendlyGrep()

let &cpo = s:save_cpo
unlet s:save_cpo
