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
  " highlight current cursorline only active window
  augroup vimrc_set_cursorline_only_active_window
    autocmd!
    autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline cursorcolumn
    autocmd WinLeave * setlocal nocursorline nocursorcolumn
  augroup END
set wrap
set scrolloff=10
" customize statusline
set laststatus=2
"set statusline=%1*%F%m%r%h%w%*\ [filetype:\ %Y]\ [fenc:\ %{&fenc}]\ [enc:\ %{&enc}]\ [ff:\ %{&ff}]\ %2*%{fugitive#statusline()}%*%=%c,%l%11p%%
hi User1 guifg=#000080 guibg=#c2bfa5
hi User2 guifg=#990000 guibg=#c2bfa5
" use this variable later
let my_own_statusline_format = '%F%m%r%h%w\ [filetype:\ %Y]\ [fenc:\ %{&fenc}]\ [enc:\ %{&enc}]\ [ff:\ %{&ff}]\ %{fugitive#statusline()}%=%c,%l%11p%%'
execute 'set statusline='.my_own_statusline_format

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

set splitright " vertical split right everytime

set modifiable
set write

set autochdir

" show matched count when search with /, ? or *
set shortmess-=S

" to prevennt to automatically fold code when you open a file
" https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
set foldlevel=99

" customoize fold text style
set foldtext=getline(v:foldstart)

" Disable vim-markdown folding. because vim-markdown sets `foldmethod=expr` arbitrarily.
let g:vim_markdown_folding_disabled = 1

" settings for M1 Mac
if system("uname -m") == "arm64\n"
  " use brew installed python for nvim-yarp (ref: https://github.com/roxma/nvim-yarp)
  let g:python3_host_prog='/opt/homebrew/bin/python3'
else
  " settings Intel Mac
  " use brew installed python
  set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.9/Python
endif

autocmd FileType php :set dictionary=~/.vim/dictionary/php.dict

" associates following extensions with filetype
autocmd BufNewFile,BufRead *.ini set filetype=php
autocmd BufNewFile,BufRead *.html set filetype=php
autocmd BufNewFile,BufRead *.rabl set filetype=ruby
autocmd BufNewFile,BufRead *.ejs set filetype=html
autocmd BufNewFile,BufRead *.cap set filetype=ruby
autocmd BufNewFile,BufRead *.cap set filetype=ruby
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.markdown set filetype=markdown

" set filetype as markdown for a new file
autocmd BufEnter * if &filetype == "project" || &filetype == "" | setlocal ft=markdown | endif

command! FullWidth :set columns=500
command! NoWrap :set nowrap
"--------------------------------------------------------------------------------------------

" set Key Map
"--------------------------------------------------------------------------------------------
" double <Esc> clears search highlight
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
noremap ; :
noremap : ;
nnoremap <SPACE> <PageDown>zz
nnoremap <S-SPACE> <PageUp>zz
" nnoremap <C-e> :<C-u>tabe $MYVIMRC<Enter>
nnoremap <C-e> :<C-u>105vs $MYVIMRC<Enter> :se nowrap<Enter>
nnoremap <C-s> :<C-u>source $MYVIMRC<Enter>
" edit zshrc
nnoremap <C-z> :<C-u>105vs $HOME/.zshrc<Enter> :se nowrap<Enter>
" open new vsplit window
nnoremap vs :<C-u>vnew<CR>
nnoremap vS :<C-u>vsplit<CR>
nnoremap <silent> <C-h> :call ShiftVbar('left', 5)<CR>
nnoremap <silent> <C-l> :call ShiftVbar('right', 5)<CR>
  function! ShiftVbar(direction, degree) "{{{
    if a:direction == 'left'
      if winnr() == 1
        let sign = '-'
      else
        let sign = '+'
      endif
  
    else
      if winnr() == 1
        let sign = '+'
      else
        let sign = '-'
      endif
  
    endif
  
    execute "vertical resize ".sign.a:degree
  endfunction "}}}

" nnoremap <S-C-j> 5<C-w>+ " comflict with IME shortcut
" nnoremap <S-C-k> 5<C-w>- " comflict with IME shortcut
" Insert new line with <RETURN> when command mode
noremap <CR> o<ESC>
" Insert new line and ; with <S-RETURN> when insert mode
inoremap <S-C-CR> <ESC>A;<ESC>o
inoremap <S-CR> <ESC>:call AppendSemiColon()<CR>a
inoremap <C-CR> <ESC>o
" move between vsplit windows
noremap <TAB> <C-w>w
noremap <C-TAB> <C-w>W
" Insert a Tab Character with <Tab> when command mode
noremap <S-TAB> i	<ESC>
" Auto Complete
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>

nnoremap <silent> <C-t> :<C-u>call SaveCurrentSession()<CR>
" execute script with quickrun.vim
nnoremap <C-q> :QuickRun<CR>
" don't register character deleted with x
nnoremap x "_x
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
nnoremap <C-g> <ESC>:FriendlyGrep<CR>
" switch file in quickfix
nnoremap <LEFT> :cprevious<CR>
nnoremap <RIGHT> :cnext<CR>
nnoremap <UP> :<C-u>cfirst<CR>
nnoremap <DOWN> :<C-u>clast<CR>
" handle octopress
nnoremap <C-n> <ESC>:OctopressNew<CR>
nnoremap <C-d> <ESC>:call DeployOctoPost()<CR>
" help settings
nnoremap ? :vertical h 
" transparent shortcut
nnoremap <silent> <S-UP> :call IncTransp()<CR>
  function! IncTransp() "{{{
    let t = 10 + &transparency
    if t <= 100
      execute 'set transparency='.t
    endif
  endfunction "}}}
nnoremap <silent> <S-DOWN> :call DecTransp()<CR>
  function! DecTransp() "{{{
    let t = &transparency - 10
    if t >= 0
      execute 'set transparency='.t
    endif
  endfunction "}}}

function! Taller() "{{{
  let n = &lines + 3
  execute 'set lines='.n
endfunction "}}}

function! Shorter() "{{{
  let n =  &lines - 3

  if 0 < n
    execute 'set lines='.n
  endif
endfunction "}}}

"--------------------------------------------------------------------------------------------
" Manage plugins with dein.vim
"
" install steps (ref: https://github.com/Shougo/dein.vim)
"   1. curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/.vim/dein_installer.sh
"   1. sh $HOME/.vim/dein_installer.sh ~/.cache/dein
"   1. exec `:call dein#install()` in vim
"--------------------------------------------------------------------------------------------
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  " ------------------------------------------------
  " describe plugin names below, then `:call dein#install()`
  "   when you delete plugins, write `call map(dein#check_clean(), \"delete(v:val, 'plugin_name_to_delete')")` (with removing backslash)
  "   then :call dein#recache_runtimepath()
  " ------------------------------------------------
  call dein#add('vim-scripts/ShowMarks')
  call dein#add('vim-scripts/surround.vim')
  " execute `$ pip3 install --user pynvim` to use denite
  "   ref https://github.com/Shougo/denite.nvim#requirements
  "
  " NOTE: specify revision to install denite.nvim working with my own `matcher/only_basename` matcher.
  "       latest denite.nvim(c5fd700) doesn't works with the matcher.
  call dein#add('Shougo/denite.nvim', { 'rev': '15f05df' })
  if !has('nvim')
    call dein#add('roxma/nvim-yarp') " needed for denite and vim 8
    call dein#add('roxma/vim-hug-neovim-rpc') " needed for denite and vim 8
  endif
  call dein#add('vim-scripts/quickrun.vim')
  call dein#add('SirVer/ultisnips')
  call dein#add('vim-scripts/The-NERD-Commenter')
  call dein#add('vim-scripts/operator-user')
  call dein#add('vim-scripts/operator-replace')
  call dein#add('kmnk/denite-dirmark') " denite bookmark alternative
  call dein#add('Shougo/vimproc')
  call dein#add('Shougo/vimshell')
  call dein#add('dense-analysis/ale')
  call dein#add('tpope/vim-rails')
  call dein#add('glidenote/octoeditor.vim')
  call dein#add('tpope/vim-fugitive')
  " call dein#add('kchmck/vim-coffee-script') " commentout for now. a error happens
  call dein#add('kshenoy/vim-signature')
  call dein#add('vim-scripts/applescript.vim')
  " call dein#add('supermomonga/projectlocal.vim')
  call dein#add('rking/ag.vim')
  call dein#add('vim-scripts/nginx.vim')
  call dein#add('kana/vim-textobj-user')
  " vim-textobj-ruby depends on vim-textobj-user.
  call dein#add('rhysd/vim-textobj-ruby')
  call dein#add('slim-template/vim-slim')
  call dein#add('plasticboy/vim-markdown')
  call dein#add('cespare/vim-toml')
  call dein#add('akira-hamada/friendly-grep.vim')
  call dein#add('hashivim/vim-terraform')
  call dein#add('HerringtonDarkholme/yats.vim')
  call dein#add('maxmellon/vim-jsx-pretty')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable
"--------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------
" setting for vim-markdown
"--------------------------------------------------------------------------------------------
let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml']
let g:vim_markdown_new_list_item_indent = 2
"--------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------
" Settings for showmarks.vim
"--------------------------------------------------------------------------------------------
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
"--------------------------------------------------------------------------------------------

"--------------------------------------
" Settings for denite
" ref
"   https://github.com/Shougo/denite.nvim/blob/master/doc/denite.txt
"   https://zaief.jp/vim/denite
"   https://qiita.com/okamos/items/4e1665ecd416ef77df7c
" how to bookmark
"   1. exec :Denite dirmark/add
"   1. hit 'b' at directory to bookmark
" TODO (upper is higher priority)
"   - deniteのcandidateの先頭の'file'という文字列を削除 (filterのマッチ対象にその文字列も入っているため)
"   - ディレクトリだけではなくファイルもbookmarkできるようにする (denite-dirmarkの制約の可能性があるので自作するしかないかも？)
"--------------------------------------
function! SetStatuslineAndCallDeniteBufferDir()
  call s:set_status_line_to_path(getcwd())

  let deniteSources = 'file file:new'
  let deniteOptions = '-start-filter -filter-split-direction=top -direction=top'
  exec 'DeniteBufferDir '.deniteSources.' '.deniteOptions
endfunction

" ファイル一覧
nnoremap <silent> ,f :call SetStatuslineAndCallDeniteBufferDir()<CR>

" ブックマーク一覧
nnoremap <silent> ,b :<C-u>Denite dirmark -start-filter -filter-split-direction=top -direction=top<CR>
" filetype一覧
nnoremap <silent> ,F :<C-u>Denite filetype -winheight=5 -start-filter -filter-split-direction=top -direction=top<CR>
nnoremap <silent> ,r :<C-u>Denite ruby_class -start-filter -filter-split-direction=top -direction=top<CR>

" settings for denite buffer
autocmd FileType denite call s:denite_my_settings()
" settings for denite filter buffer
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! CreateFileRecursively() abort
  let l:fullpath = g:my_own_denite_filter_buffer_statusline_contents. '/' .getline(1, '$')[-1]
  let l:nodes = split(l:fullpath, '/')
  let l:nodes_except_last = l:nodes[0:(len(l:nodes) - 2)]
  let l:directory = '/'.join(l:nodes_except_last, '/')

  if isdirectory(l:directory) == 0
    if filereadable(l:directory) == 0
      call mkdir(l:directory, 'p')
      echo 'New directory created: '. l:directory
    endif
  endif
  silent execute 'tabnew ' . l:fullpath
  echo 'New File: '. l:fullpath
  " TODO close remaining denite buffer and filter
endfunction

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action', 'my_own_action_by_selected_kind')
  nnoremap <silent><buffer><expr> <C-CR>  denite#do_map('do_action')
  nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> u       denite#do_map('do_action', 'my_move_up_path')
  nnoremap <silent><buffer><expr> <C-w>   denite#do_map('do_action', 'my_move_up_path')
  nnoremap <silent><buffer><expr> b       denite#do_map('do_action', 'add')
  nnoremap <silent><buffer><expr> v       denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q       denite#do_map('quit')
  " nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
  " nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction
function! s:denite_filter_my_settings() abort
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action', 'my_own_action_by_selected_kind')
  inoremap <silent><buffer><expr> <C-CR> denite#do_map('do_action')
  inoremap <S-CR> <ESC>:call CreateFileRecursively()<CR>
  " Close denite filter buffer when I hit jk (when I escape insert mode)
  imap <silent><buffer> jk <Plug>(denite_filter_quit)
  " this is for incoming denite version issue (ref: https://github.com/Shougo/denite.nvim/issues/835)
  " imap <silent><buffer> jk <Plug>(denite_filter_update)
  inoremap <silent><buffer><expr> <C-w> denite#do_map('do_action', 'move_up_path_if_empty_input')
  " ref for following actions: https://zaief.jp/vim/denite
  " toggle_select
  " inoremap <silent><buffer><expr> <C-j> denite#do_map('toggle_select')
endfunction

let g:my_own_denite_filter_buffer_statusline_contents = getcwd()
" set statusline
function! s:set_status_line_to_path(path)
  let g:my_own_denite_filter_buffer_statusline_contents = a:path
  silent execute 'set statusline=' . a:path
endfunction

" Open file with new tab.
function! s:my_own_denite_open_file_with_new_tab_for_file(context) abort
  call denite#do_action(a:context, 'tabopen', a:context.targets)
endfunction
function! s:my_own_denite_open_file_with_new_tab_for_directory(context) abort
  call s:set_status_line_to_path(a:context['targets'][0]['action__path'])

  let narrow_dir = denite#util#path2directory(a:context['targets'][0]['action__path'])
  let sources_queue = [
    \ {'name': 'file', 'args': [0, narrow_dir]},
    \ {'name': 'file', 'args': ['new', narrow_dir]}
  \ ]

  return {'sources_queue': [sources_queue], 'path': a:context['targets'][0]['action__path']}
endfunction
function! s:my_own_denite_open_file_with_new_tab_for_dirmark(context) abort
  if filereadable(a:context['targets'][0]['action__path'])
    " bookmarkがファイルの場合
    silent execute 'tabnew ' . a:context['targets'][0]['action__path']
  else " bookmarkがdirectoryの場合
    call s:set_status_line_to_path(a:context['targets'][0]['action__path'])

    let narrow_dir = denite#util#path2directory(a:context['targets'][0]['action__path'])
    let sources_queue = [
      \ {'name': 'file', 'args': [0, narrow_dir]},
      \ {'name': 'file', 'args': ['new', narrow_dir]}
    \ ]

    return {'sources_queue': [sources_queue], 'path': a:context['targets'][0]['action__path']}
  endif
endfunction
function! s:my_own_denite_open_file_with_new_tab_for_filetype(context) abort
  execute a:context.targets[0].action__command
endfunction

" cd parent_directory for denite.
" because denite move_up_path doesn't work with my_own_denite_open_file_with_new_tab function.
function! s:my_own_denite_move_up_path(context) abort
  let parent_path = fnamemodify(a:context['path'], ':h')
  call s:set_status_line_to_path(parent_path)

  let narrow_dir = denite#util#path2directory(parent_path)
  let sources_queue = [
    \ {'name': 'file', 'args': [0, narrow_dir]},
    \ {'name': 'file', 'args': ['new', narrow_dir]}
  \ ]

  return {'sources_queue': [sources_queue], 'path': parent_path}
endfunction
function! s:my_own_denite_move_up_path_if_empty_input(context) abort
  if a:context['input'] == ''
    let path = fnamemodify(a:context['path'], ':h')
  else
    let path = a:context['path']
  endif

  call s:set_status_line_to_path(path)

  let narrow_dir = denite#util#path2directory(path)
  let sources_queue = [
    \ {'name': 'file', 'args': [0, narrow_dir]},
    \ {'name': 'file', 'args': ['new', narrow_dir]}
  \ ]

  return {'sources_queue': [sources_queue], 'path': path}
endfunction

" call different function by selected kind (ref: denite help of denite#custom#action function)
call denite#custom#action('file',            'my_own_action_by_selected_kind', function('s:my_own_denite_open_file_with_new_tab_for_file'))
call denite#custom#action('directory',       'my_own_action_by_selected_kind', function('s:my_own_denite_open_file_with_new_tab_for_directory'))
call denite#custom#action('dirmark',         'my_own_action_by_selected_kind', function('s:my_own_denite_open_file_with_new_tab_for_dirmark'))
call denite#custom#action('source/filetype', 'my_own_action_by_selected_kind', function('s:my_own_denite_open_file_with_new_tab_for_filetype'))

call denite#custom#action('file,directory', 'my_move_up_path', function('s:my_own_denite_move_up_path'))
call denite#custom#action('file,directory', 'move_up_path_if_empty_input', function('s:my_own_denite_move_up_path_if_empty_input'))

" my own macher ,converter and sorter.
call denite#custom#source('file', 'matchers', ['matcher/only_basename'])
" call denite#custom#source('file', 'converters', ['converter/full_path_abbr'])
call denite#custom#source('file', 'sorters', ['sorter/case_insensitive'])

autocmd InsertLeave * call WhenLeaveInsertMode(my_own_statusline_format)

function WhenLeaveInsertMode(statusline_format)
    if &ft =~ 'denite-filter'
      execute 'set statusline='.a:statusline_format
    endif
endfunction
"--------------------------------------

"----------------------------------------------------------------------------
" settings for ultisnips(snippets)
" TODO: 既存のsnippetや設定を移行する
"       ref
"         - https://github.com/kenjinino/vim-ultisnips-ruby/blob/master/ruby_snipmate.snippets
"----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = "<C-k>"
let g:UltiSnipsJumpForwardTrigger = "<C-k>"
let g:UltiSnipsJumpBackwardTrigger = "<C-b>"

let g:UltiSnipsEditSplit="vertical"
" load my own snippets (.vim/snippets/ is old directory)
let g:UltiSnipsSnippetDirectories = ['UltiSnips',$HOME.'/.vim/UltiSnips']
" edit snippets file
nnoremap <silent> <C-f> :UltiSnipsEdit<CR>

" customize neocomplcache.vim
" let g:neocomplcache_enable_auto_select = 1 " auto select first of options
" let g:neocomplcache_auto_completion_start_length = 3 " start to complete after 3 chars
" let g:neocomplcache_lock_iminsert = 1 " not use neocomplcache when IME is ON

"----------------------------------------------------------------------------

" -------------------------------
" settings for ALE
let g:ale_fixers = { 'ruby': ['rubocop'], }
" -------------------------------

" customize NERD-Commenter
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1
nmap <C-c> <Plug>NERDCommenterToggle
vmap <C-c> <Plug>NERDCommenterToggle
vnoremap <silent> <C-d> :call DupLines()<CR>
  function! DupLines()  range "{{{
    let selected_num = line("'>") - line("'<") + 1
    let ori_pos = line("'<")
    " 選択中の行をyank
    normal! ""gvy
    " yankした物をPする
    normal P
    " selected_numの分、下に移動する
    execute 'normal '.selected_num.'j'
    " Vモードに入る
    execute 'normal V'.selected_num.'j'
    " コメントアウトする
    call NERDComment(1, 'norm')
    " ビジュアルモードからエスケープ
    execute "normal! \e\e"
    " 元の位置に戻る
    execute 'normal '.ori_pos.'gg'
  endfunction "}}}

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
" let g:friendlygrep_target_dir = join(readfile(glob('~/dotfiles/.vim/friendly_grep_search_root_path')), "\n")
let g:friendlygrep_recursively = 1
let g:friendlygrep_display_result_in = 'tab'
"--------------------------------------------------------------------------------------------
" customize cursor shape for terminal
"   ref: https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
" | for insert mode
let &t_SI .= "\e[5 q"
" block cursor for normal mode
let &t_EI .= "\e[2 q"
" blinking under cursor for replace mode
let &t_SR .= "\e[3 q"
"--------------------------------------------------------------------------------------------

" vim script
"--------------------------------------------------------------------------------------------
"matchit.vimを有効化
source $VIMRUNTIME/macros/matchit.vim

" タブを開いた時の元のタブがからの場合閉じる
autocmd TabEnter * call ClosePreviousEmptyTab()

"--------------------------------------------------------
"  現在のバッファが新規作成で空のバッファの場合1を返す
"     Test it like this
"     echo BufferIsEmpty()
"--------------------------------------------------------
function! BufferIsEmpty()
    " ファイルの内容が空
    if line('$') == 1 && getline(1) == ''
        if expand('%:t') == ''
          return 1
        else
          return 0
        endif
    else
        return 0
    endif
endfunction

"--------------------------------------------------------
"  一つ前のタブに移動し空かどうかで以下の処理を行う
"  空: 閉じる
"  何らか入力されている: 元のタブへ移動
"     Test it like this
"     call CloseIfBufferEmpty()
"--------------------------------------------------------
function! ClosePreviousEmptyTab()
    exe 'normal! gT'
    if BufferIsEmpty() == 1
        exe 'q!'
    else
        exe 'normal! gt'
    endif
endfunction

"----------------------------------------
function! s:Preserve()
  " Save cursor position
  let l = line(".")
  let c = col(".")

  execute '?^\s*\(describe\|it\|context\|feature\|scenario\)\(.*\) do$'
  execute 's/\(describe\|it\|context\|feature\|scenario\)\(.*\) do$/\1\2, :focus do/'

  " Restore cursor position
  call cursor(l, c)
  " Remove search history pollution and restore last search
  call histdel("search", -2)
  let @/ = histget("search", -2)
endfunction

function! s:AddFocusTag()
  call s:Preserve()
endfunction

function! s:RemoveAllFocusTags()
  call s:Preserve("%s/, :focus//e")
endfunction

" Commands
command! -nargs=0 AddFocusTag call s:AddFocusTag()
command! -nargs=0 RemoveAllFocusTags call s:RemoveAllFocusTags()

"--------------------------------------------------------
"  execute rspec in vim terminal (requires vim 8)
"--------------------------------------------------------
" 参考: https://qiita.com/kasei-san/items/060bbd267ddc0cca5068
function! ExecuteRSpec(...)
    " 引数がある場合
    if a:0 >= 1
      " 引数を実行対象のspecとする
      let spec = a:1
    else
      " コマンド実行時にカーソルがある行のspecを実行
      let spec = expand('%:p') . ':' . line('.')
    end

    " let opts = { 'vertical': '1', 'term_cols': 60, 'hidden': '1', 'term_finish': 'open', 'term_opencmd': '60vsplit|buffer %d' }
    let opts = { 'vertical': '1', 'term_cols': 60 }

    let command = './rspec.zsh some_dir ' . spec
    call term_start(command, opts)
    " TODO: コマンド(spec)実行時のカーソルを編集中のファイルに移したい
endfunction
command! -nargs=? RSpec call ExecuteRSpec(<f-args>)
nnoremap rs <ESC>:RSpec<CR>
" ↑本当は ctrl-shift-rとかで実行したい。ctrl-shiftは無理っぽい
" nnoremap <C-S-r> <ESC>:RSpec<CR>

"--------------------------------------------------------------------------------------------
" MacVim original settings
"   Put these on the end of .vimrc.
"   because some plugin or setting override hi Tag* settings probably.
"--------------------------------------------------------------------------------------------
if has('multi_byte_ime') || has('gui_macvim')
" following lines run only with MacVim
  set guifont=Ricty\ Diminished\ bold:h14
  command! ResetFont :set guifont=Ricty\ Diminished\ bold:h14
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
