" Basic Settings
"--------------------------------------------------------------------------------------------
filetype plugin indent on
syntax enable
set enc=utf-8
set fenc=utf-8
set ff=unix
set ffs=unix,dos,mac
" customize indent
set autoindent
set nosmartindent
set ts=4
colorscheme desert
set number
set ruler
set cursorline
set wrap
" customize statusline
set laststatus=2
set statusline=%F%m%r%h%w\ [filetype:\ %Y]\ [fenc:\ %{&fenc}]\ [enc:\ %{&enc}]\ [ff:\ %{&ff}]%=%c,%l%11p%%
" customize search
set hlsearch
set wrapscan
set incsearch
" ignore case when you search characters, but don't ignore case when you search upper case.
set ignorecase smartcase
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set mouse=a
" swap files
set swapfile
set directory=~/.vim/swap
" backup files
set backup
set backupdir=~/.vim/backup
"--------------------------------------------------------------------------------------------

" MacVim original settings
"--------------------------------------------------------------------------------------------
if has('multi_byte_ime') || has('gui_macvim')
" following lines run only with MacVim
  set guifont=Ricty:h14
  " don't display menu bar
  set guioptions-=T
  " don't beep
  set visualbell t_vb=
  " if you yank words, it's shared with clipboard
  set clipboard=unnamed,autoselect
  " when IME enabled, set cursor following color
  highlight CursorIM guibg=skyBlue guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0  
  " 挿入モードでのIME状態を記憶させない
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
  set noimdisable
  " pop-up menu color
  highlight Pmenu guibg=white guifg=black
  highlight PmenuSel guibg=black guifg=white
endif
"--------------------------------------------------------------------------------------------

" set Key Map
"--------------------------------------------------------------------------------------------
" double <Esc> clears search highlight
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
noremap ; :
noremap : ;
nnoremap <SPACE> <PageDown>zz
nnoremap <S-SPACE> <PageUp>zz
nnoremap <C-e> :<C-u>tabe $MYVIMRC<Enter>
nnoremap <C-s> :<C-u>source $MYVIMRC<Enter>
" Insert new line with <RETURN> when command mode
noremap <CR> o<ESC>
" Insert new line and ; with <S-RETURN> when insert mode
inoremap <S-CR> <ESC>A;<ESC>o
" Insert a Tab Character with <Tab> when command mode
noremap <TAB> i	<ESC>
" Auto Complete
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
" go to normal mode with <C-j>
inoremap <C-j> <C-[>
vnoremap <C-j> <C-[>
" open file browser with Unite
nnoremap <silent> ,f :<C-u>UniteWithBufferDir -buffer-name=files file file_mru bookmark<CR>
" open snippet with Neocomplcache
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
" open snippets file
nnoremap <silent> <C-f> :<C-u>tabe %<CR>:<C-u>NeoComplCacheEditSnippets <CR>
" execute script with quickrun.vim
nnoremap <C-q> :QuickRun<CR>
nnoremap ,p viwp
" don't register character deleted with x
nnoremap x "_x
" Change inner word (ciw)
nnoremap C ciw
" move page tab
nnoremap H gT
nnoremap L gt
"--------------------------------------------------------------------------------------------

" manage plugins with vundle
"--------------------------------------------------------------------------------------------
set nocompatible
filetype off

set rtp+=~/.vim/vundle.git/
call vundle#rc()
" describe plugin names below
" how to describe
"	1. if it's in vim-scripts repository (http://vim-scripts.org/vim/scripts.html)
"			Bundle 'script_name'
"	2. if it's in original github repository (https://github.com/)
"			Bundle 'github_user_name/repository_name'
"	3. if it's in none github repository
"			Bundle 'git://repository_url'
"------------------------------------------------------------------------------------
Bundle "eregex.vim"
Bundle "ShowMarks"
Bundle "surround.vim"
Bundle "unite.vim"
Bundle "quickrun.vim"
Bundle "neocomplcache"
Bundle "The-NERD-Commenter"

filetype plugin indent on
"--------------------------------------------------------------------------------------------

" etc settings
"--------------------------------------------------------------------------------------------
" change directory to where the opend file is
"au BufEnter * execute ":|cd " . expand("%:p:h")
autocmd FileType php :set dictionary=~/.vim/dictionary/php.dict
" associates following extensions with php
autocmd BufNewFile,BufRead *.ini set filetype=php
autocmd BufNewFile,BufRead *.html set filetype=php

" customize showmarks.vim
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" customize unite.vim
let g:unite_enable_start_insert = 1 " start unite with insert mode
" open in splited right window with v
au FileType unite nnoremap <silent> <buffer> <expr>v unite#do_action('right')

" customize neocomplcache.vim
let g:neocomplcache_enable_at_startup = 1 " enable neocomplcache at starting vim
let g:neocomplcache_enable_auto_select = 1 " auto select first of options
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets' " load snippets from this directory

" customize NERD-Commenter
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1
nmap <C-c> <Plug>NERDCommenterToggle
vmap <C-c> <Plug>NERDCommenterToggle
"--------------------------------------------------------------------------------------------
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
