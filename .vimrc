" vim customize todo
"--------------------------------------------------------------------------------------------
" change tab interface characters size into small
"
"--------------------------------------------------------------------------------------------
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
set tabstop=4
set shiftwidth=4

colorscheme desert
set number
set ruler
set cursorline
set wrap
set scrolloff=10
" customize statusline
set laststatus=2
set statusline=%F%m%r%h%w\ [filetype:\ %Y]\ [fenc:\ %{&fenc}]\ [enc:\ %{&enc}]\ [ff:\ %{&ff}]\ %{fugitive#statusline()}%=%c,%l%11p%%
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
" add plugin dir to runtimepath
:set runtimepath+=$HOME/.vim/plugin
"--------------------------------------------------------------------------------------------

" MacVim original settings
"--------------------------------------------------------------------------------------------
if has('multi_byte_ime') || has('gui_macvim')
" following lines run only with MacVim
  set guifont=Ricty\ bold:h14
  set cursorcolumn " display vertical cursor line
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

  set guioptions-=e "tablineを使う
  set tabline=%!MakeTabLine()
  hi TabLineSel ctermfg=Black ctermbg=White guifg=Black guibg=White
  hi TabLine ctermfg=Black ctermfg=Gray ctermbg=black guifg=White guibg=grey21
  hi TabLineFill ctermbg=black guifg=grey8
  
	
    function! MakeTabLine() "{{{
      let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
      let sep = ' '  " タブ間の区切り
      let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
      let info = ''  " 好きな情報を入れる
      return tabpages . '%=' . info  " タブリストを左に、情報を右に表示
    endfunction "}}}

    function! s:tabpage_label(n) "{{{
      " t:title と言う変数があったらそれを使う
      let title = gettabvar(a:n, 'title')
      if title !=# ''
        return title
      endif

      " タブページ内のバッファのリスト
      let bufnrs = tabpagebuflist(a:n)

      " カレントタブページかどうかでハイライトを切り替える
      let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

      " バッファが複数あったらバッファ数を表示
      let no = len(bufnrs)
      if no is 1
        let no = ''
      endif
      " タブページ内に変更ありのバッファがあったら '+' を付ける
      let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
      let sp = (no . mod) ==# '' ? '' : ' '  " 隙間空ける

      " カレントバッファ
      let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
      let file = bufname(curbufnr)
      let fname= fnamemodify(file, ':p:t')
      if fname == ''
        let fname = '[No Name]'
	  end

      let label = no . mod . sp . fname

      return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
    endfunction "}}}
  
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
inoremap <S-C-CR> <ESC>A;<ESC>o
inoremap <S-CR> <ESC>:call AppendSemiColon()<CR>a
inoremap <C-CR> <ESC>o
" Insert a Tab Character with <Tab> when command mode
noremap <TAB> i	<ESC>
" Auto Complete
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
" open file browser with Unite
nnoremap <silent> ,f :<C-u>UniteWithBufferDir -buffer-name=files file file_mru file/new<CR>
nnoremap <silent> ,b :<C-u>Unite -buffer-name=files bookmark file<CR>
nnoremap <silent> ,m :<C-u>UniteWithBufferDir -buffer-name=files file_mru<CR>
" open snippet with Neocomplcache
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
" edit snippets file
nnoremap <silent> <C-f> :<C-u>tabe %<CR>:<C-u>NeoSnippetEdit<CR>
" execute script with quickrun.vim
nnoremap <C-q> :QuickRun<CR>
nnoremap ,p viwp
" don't register character deleted with x
nnoremap x "_x
" Change inner word (ciw)
nnoremap C ciw
" Change inner space
nnoremap ci<Space> ciW
" delete inner space
nnoremap di<Space> diW
" move page tab
nnoremap H gT
nnoremap L gt
inoremap jk <Esc>
nmap R <Plug>(operator-replace)
nnoremap <C-j> `
nnoremap / /\v
" close buffer with q, not :q<enter>
nnoremap q :<C-u>q<CR>
" record macro with Q, not q
nnoremap Q q

" grep friendly
nnoremap <C-g> <ESC>:call FriendlyGrep()<CR>
" switch file in quickfix
nnoremap <LEFT> :cprevious<CR>
nnoremap <RIGHT> :cnext<CR>
nnoremap <UP> :<C-u>cfirst<CR>
nnoremap <DOWN> :<C-u>clast<CR>
" handle octopress
nnoremap <C-n> <ESC>:OctopressNew<CR>
nnoremap <C-d> <ESC>:call DeployOctoPost()<CR>
"--------------------------------------------------------------------------------------------

" manage plugins with vundle
"--------------------------------------------------------------------------------------------
set nocompatible
filetype off

set rtp+=~/.vim/vundle.git/
call vundle#rc()
" describe plugin names below
" :BundleInstall
" how to describe
"	1. if it's in vim-scripts repository (http://vim-scripts.org/vim/scripts.html)
"			Bundle 'script_name'
"	2. if it's in original github repository (https://github.com/)
"			Bundle 'github_user_name/repository_name'
"	3. if it's in none github repository
"			Bundle 'git://repository_url'
" 
" when you delete plugin, execute :BundleClean after deleting the Bundle ~ line to delete
"------------------------------------------------------------------------------------
Bundle 'ShowMarks'
Bundle 'surround.vim'
Bundle 'unite.vim'
Bundle 'quickrun.vim'
Bundle 'Shougo/neocomplcache.git'
Bundle 'Shougo/neosnippet.git'
Bundle 'The-NERD-Commenter'
Bundle 'operator-user'
Bundle 'operator-replace'
Bundle 'git://github.com/Shougo/vimproc'
Bundle 'git://github.com/Shougo/vimshell'
Bundle 'git://github.com/tpope/vim-rails'
Bundle 'glidenote/octoeditor.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'kchmck/vim-coffee-script'

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
call unite#custom_default_action('file', 'tabopen') " open a file in new tab
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
	" delete backslash with the words by <C-w> when insertmode in Unite
	imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
endfunction

" open in splited right window with v
au FileType unite nnoremap <silent> <buffer> <expr>v unite#do_action('right')


" customize neocomplcache.vim
let g:neocomplcache_enable_at_startup = 1 " enable neocomplcache at starting vim
let g:neocomplcache_enable_auto_select = 1 " auto select first of options
let g:neocomplcache_auto_completion_start_length = 3 " start to complete after 3 chars
let g:neocomplcache_lock_iminsert = 1 " not use neocomplcache when IME is ON

" load snippets from this directory
let g:neosnippet#snippets_directory= $HOME.'/.vim/snippets'

" customize NERD-Commenter
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1
nmap <C-c> <Plug>NERDCommenterToggle
vmap <C-c> <Plug>NERDCommenterToggle

" customize surround.vim
let g:surround_{char2nr("[")} = "[\r]"
let g:surround_{char2nr("\{")} = "{\r}"
let g:surround_{char2nr("\(")} = "(\r)"

" customize octoeditor.vim
let g:octopress_path = '~/rails_projects/octopress'
let g:octopress_post_suffix = "markdown"
let g:octopress_post_date = "%Y-%m-%d %H:%M"
let g:octopress_published = 1
let g:octopress_comments = 1
let g:octopress_prompt_tags = 0
let g:octopress_prompt_categories = 1
let g:octopress_qfixgrep = 0
let g:octopress_vimfiler = 0
" let g:octopress_template_dir_path = 'path/to/dir'
"
" customize friendly_grep
let g:friendlygrep_target_dir = 'rails_projects/tabishare/app/views/components/log_in/'
let g:friendlygrep_recursively = 1
let g:friendlygrep_display_result_in = 'tab'
"--------------------------------------------------------------------------------------------
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"--------------------------------------------------------------------------------------------

" vim script
"--------------------------------------------------------------------------------------------
"matchit.vimを有効化
source $VIMRUNTIME/macros/matchit.vim
