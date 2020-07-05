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

set splitright " vertical split right everytime

set modifiable
set write

command! FullWidth :set columns=500
command! NoWrap :set nowrap
"--------------------------------------------------------------------------------------------

" MacVim original settings
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
" open file browser with Unite
nnoremap <silent> ,f :<C-u>UniteWithBufferDir -buffer-name=files file file_mru file/new<CR>
nnoremap <silent> ,b :<C-u>Unite bookmark<CR>
" nnoremap <silent> ,b :<C-u>Unite -buffer-name=files bookmark file<CR>
nnoremap <silent> ,m :<C-u>UniteWithBufferDir -buffer-name=files file_mru<CR>
nnoremap <silent> ,t :<C-u>Unite branches<CR>
nnoremap <silent> ,pv :<C-u>Unite pivotal<CR>
nnoremap <silent> ,F :<C-u>Unite filetype<CR>

nnoremap <silent> <C-t> :<C-u>call SaveCurrentSession()<CR>
" open snippet with Neocomplete(ex: Neocomplcache)
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
" edit snippets file
nnoremap <silent> <C-f> :<C-u>tabe %<CR>:<C-u>NeoSnippetEdit<CR>
" execute script with quickrun.vim
nnoremap <C-q> :QuickRun<CR>
" FIXME not in use
nnoremap ,p viwp
" don't register character deleted with x
nnoremap x "_x
" Change inner word (ciw) FIXME not in use
nnoremap C ciw
" Change inner space FIXME not in use
nnoremap ci<Space> ciW
" delete inner space FIXME not in use
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

nnoremap <expr> / _(":%s/<Cursor>/&/gn")
function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
    return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction

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
"
" manage plugins with dein.vim
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
  " call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/denite.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp') " needed for denite and vim 8
    call dein#add('roxma/vim-hug-neovim-rpc') " needed for denite and vim 8
  endif
  call dein#add('vim-scripts/quickrun.vim')
  call dein#add('Shougo/neocomplete')
  call dein#add('vim-scripts/The-NERD-Commenter')
  call dein#add('vim-scripts/operator-user')
  call dein#add('vim-scripts/operator-replace')
  call dein#add('Shougo/vimproc')
  call dein#add('Shougo/vimshell')
  call dein#add('tpope/vim-rails')
  call dein#add('glidenote/octoeditor.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('kchmck/vim-coffee-script')
  call dein#add('kshenoy/vim-signature')
  call dein#add('vim-scripts/applescript.vim')
  " call dein#add('supermomonga/projectlocal.vim')
  call dein#add('rking/ag.vim')
  " call dein#add('osyo-manga/unite-filetype')
  call dein#add('vim-scripts/nginx.vim')
  call dein#add('kana/vim-textobj-user')
  " vim-textobj-ruby depends on vim-textobj-user.
  call dein#add('rhysd/vim-textobj-ruby')
  call dein#add('slim-template/vim-slim')
  call dein#add('plasticboy/vim-markdown')
  call dein#add('akira-hamada/friendly-grep.vim')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable
"--------------------------------------------------------------------------------------------


" etc settings
"--------------------------------------------------------------------------------------------
" change directory to where the opend file is
"au BufEnter * execute ":|cd " . expand("%:p:h")
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
" autocmd BufEnter * if &filetype == "project" | setlocal ft=markdown | endif

" setting for markdown
let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml']

" customize showmarks.vim
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

"--------------------------------------
" settings for denite
"--------------------------------------
" 現在開いているファイルのディレクトリ下のファイル一覧
nnoremap <silent> ,f :<C-u>DeniteBufferDir -direction=topleft file file:new<CR>
"ブックマーク一覧
nnoremap <silent> ,b :<C-u>Denite -direction=topleft bookmark<CR>
"--------------------------------------

" customize unite.vim
" let g:unite_enable_start_insert = 1 " start unite with insert mode
" let g:unite_force_overwrite_statusline = 1 " setting for statusline of Unite window
" call unite#custom_default_action('file', 'tabopen') " open a file in new tab
" autocmd FileType unite call s:unite_my_settings()
" function! s:unite_my_settings()
	" " delete backslash with the words by <C-w> when insertmode in Unite
	" imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " nmap <buffer> q <Plug>(unite_all_exit)
  " nmap <buffer> <Space> 10j
  " nmap <buffer> <S-SPACE> 10k
" endfunction

" " open in splited right window with v
" au FileType unite nnoremap <silent> <buffer> <expr>v unite#do_action('right')

" nnoremap <silent> ,m  :<C-u>call Unite_rails('models', '-start-insert')<CR>
" nnoremap <silent> ,v  :<C-u>call Unite_rails('views', '-start-insert')<CR>
" nnoremap <silent> ,c  :<C-u>call Unite_rails('controllers', '-start-insert')<CR>
" nnoremap <silent> ,h  :<C-u>call Unite_rails('helpers', '-start-insert')<CR>
" nnoremap <silent> ,g  :<C-u>call Unite_rails('config', '-start-insert')<CR>
" nnoremap <silent> ,l  :<C-u>call Unite_rails('locales', '-start-insert')<CR>
" nnoremap <silent> ,j  :<C-u>call Unite_rails('javascripts', '-start-insert')<CR>
" nnoremap <silent> ,s  :<C-u>call Unite_rails('stylesheets', '-start-insert')<CR>
" nnoremap <silent> ,d  :<C-u>call Unite_rails('db', '-start-insert')<CR>
" nnoremap <silent> ,r  :<C-u>call Unite_rails('spec', '-start-insert')<CR>
" function! Unite_rails(target, options)
  " if exists('b:projectlocal_root_dir')
    " if a:target == 'models' || a:target == 'views' || a:target == 'controllers' || a:target == 'helpers'
      " let dir = '/app/'.a:target
    " elseif a:target == 'config'
      " let dir = '/config/'
    " elseif a:target == 'locales'
      " let dir = '/config/locales/'
    " elseif a:target == 'javascripts' || a:target == 'stylesheets'
      " let dir = '/app/assets/'.a:target
    " elseif a:target == 'db'
      " let dir = '/db/'
    " elseif a:target == 'spec'
      " let dir = '/spec/'
    " endif
    " execute ':Unite file_rec:' . b:projectlocal_root_dir . dir . ' ' . a:options
  " else
    " echo "You are not in any project."
  " endif
" endfunction

" customize neocomplcache.vim
" let g:neocomplcache_enable_at_startup = 1 " enable neocomplcache at starting vim
" let g:neocomplcache_enable_auto_select = 1 " auto select first of options
" let g:neocomplcache_auto_completion_start_length = 3 " start to complete after 3 chars
" let g:neocomplcache_lock_iminsert = 1 " not use neocomplcache when IME is ON

" load snippets from this directory
let g:neosnippet#snippets_directory= $HOME.'/.vim/snippets'

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
let g:friendlygrep_target_dir = 'code/somewhere/*'
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

" ----------------------------------------------------------------------------------------
" Unite-branches
" ----------------------------------------------------------------------------------------
" let s:date_sort_filter = {
" \   "name" : "sorter_date",
" \}

" function! s:date_sort_filter.filter(candidates, context)
    " return unite#util#sort_by(a:candidates, 'v:val.action__date')
" endfunction

" " unite.vim に filter を登録
" call unite#define_filter(s:date_sort_filter)
" unlet s:date_sort_filter

" let s:format_filter = {
" \   "name" : "format_candidate",
" \}

" " candidateの表示formatを決定するfilter
" function! s:format_filter.filter(candidates, context)
    " let format = "(%-S) %-S"

    " for candidate in a:candidates
      " let datetime = strftime("%Y-%m-%d %H:%M:%S", candidate.action__date)
      " let candidate.word = printf(format, datetime, candidate.action__branch_name)
    " endfor

    " return a:candidates
" endfunction

" " unite.vim に filter を登録
" call unite#define_filter(s:format_filter)
" unlet s:format_filter

" " unite-source の設定を定義する (詳しい設定オプションは :help unite-source-attributes)
" let s:source = {
" \   "name" : "branches",
" \   "description" : "git branches",
" \   "action_table" : {
" \       "restore_session" : {
" \           "description" : "restore session for the branch",
" \       },
" \
" \       "delete_from_branch" : {
" \           "description" : "delete from list",
" \       }
" \   },
" \   "default_action" : "restore_session",
" \}

" " action が呼ばれた時の処理を定義
" function! s:source.action_table.restore_session.func(candidate)
  " let branch_file = a:candidate.action__path " candidate には gather_candidates で設定した値が保持されている

  " execute 'source '.branch_file
  " execute 'source '.$MYVIMRC
" endfunction

" function! s:source.action_table.delete_from_branch.func(candidate)
  " call delete(a:candidate.action__path)
" endfunction

" " unite.vim で表示される候補を返す
" function! s:source.gather_candidates(args, context)

    " let globed_files = glob(g:unite_data_directory.'/branches/*')
    " let branch_list = split(globed_files, '\n')

    " let branches = []
    " for branch_path in branch_list
      " let branch_name = substitute(fnamemodify(branch_path, ":t"), '__', '/', 'g')

      " redir => tmp
      " silent exe '!tail -n 1 '.branch_path
      " redir END
      " let localtime = split(tmp, '\r\n')[1]
      " let localtime = substitute(localtime, '^"\s\(\d\+\)$', '\1', '')

      " let candidate_info = {
" \        'word': branch_name,
" \        'action__branch_name': branch_name,
" \        'action__date': localtime,
" \        'action__path': branch_path,
" \        'source': 'branches'
" \      }
      " call add(branches, candidate_info)
    " endfor

    " return branches
" endfunction

" " branhcesソースに candidateを追加
" function! SaveCurrentSession()
  " execute 'cd %:h'
  " let branch_name = system('git symbolic-ref --short HEAD')
  " execute 'cd -'

  " try
    " if 0 <= match(branch_name, 'Not a git repository')
      " throw 'Error: Not a git repository'
    " endif
  " catch
    " echohl WarningMsg | echo v:exception | echohl None
    " return
  " endtry

  " let original_branch_name = substitute(branch_name, '\n', '', '')
  " let branch_name = substitute(original_branch_name, '/', '__', 'g')

  " exe "mksession! " .g:unite_data_directory.'/branches/'.branch_name

  " let insert_this = "'".'" '.localtime()."'"
  " silent exe '!echo '.insert_this.'  >> '.g:unite_data_directory.'/branches/'.branch_name

  " redraw | echo 'Save Current Session to '."'".original_branch_name."'"
" endfunction

" " untie.vim に source を登録
" call unite#define_source(s:source)
" unlet s:source

" call unite#custom_source('branches', 'converters', 'format_candidate')

" call unite#custom_source('branches', 'sorters', ['sorter_date', 'sorter_reverse'])

" ----------------------------------------------------------------------------------------
" Unite-pivotal
" ----------------------------------------------------------------------------------------
" unite-source の設定を定義する (詳しい設定オプションは :help unite-source-attributes)
" let s:source = {
" \   "name" : "pivotal",
" \   "description" : "pivotal tracker",
" \   "action_table" : {
" \       "copy_story_url" : {
" \           "description" : "copy url to story page",
" \       }
" \   },
" \   "default_action" : "copy_story_url",
" \}

" " action が呼ばれた時の処理を定義
" function! s:source.action_table.copy_story_url.func(candidate)
  " let branch_file = a:candidate.action__path " candidate には gather_candidates で設定した値が保持されている

  " 'https://www.pivotaltracker.com/story/show/'.story_id
" endfunction

" " unite.vim で表示される候補を返す
" function! s:source.gather_candidates(args, context)

    " redir => stories
    " silent exe '!pv'
    " redir END

    " let stories = split(stories, '\n')

    " for story in stories
      " let story_id = substitute(story, '^\*\s\(\d\+\)\s.\+$', '\1', '')

      " let candidate_info = {
" \        'word': story,
" \        'action__story_id': story_id,
" \        'source': 'pivotal'
" \      }
      " call add(stories, candidate_info)
    " endfor

    " return stories
" endfunction

" " untie.vim に source を登録
" call unite#define_source(s:source)
" unlet s:source

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

" for http://secret-garden.hatenablog.com/entry/2017/10/10/120951
se redrawtime=2000

" ----------------------------------------------------------------------------------------
" Unite-pull_requests
" ----------------------------------------------------------------------------------------
" nnoremap <silent> ,pr :<C-u>Unite pull_requests<CR>
" " unite-source の設定を定義する (詳しい設定オプションは :help unite-source-attributes)
" let s:source = {
" \   "name" : "pull_requests",
" \   "description" : "github_prs",
" \   "action_table" : {
" \       "view_pr" : {
" \           "description" : "view PRs",
" \       }
" \   },
" \   "default_action" : "view_pr",
" \}

" " view_pr action (Unite-pull_requestsから実行可能)
" function! s:source.action_table.view_pr.func(candidate)
  " let pr_id = a:candidate.action__pr_id " candidate には gather_candidates で設定した値が保持されている
  " let pr = 'pr-'.pr_id
  " let pr_diff_file = pr.'.diff'
  " echo('Creating ' .pr. ' diff file...')

  " exe 'cd $HOME/somewhere/'
  " silent exe '!git fetch upstream pull/' . pr_id . '/head:'. pr
  " silent exe '!git checkout ' . pr
  " " TODO: baseブランチがrelease以外に対応
  " let commit_num = system('git log release..head --oneline|wc -l|tr -d " \n"')
  " " ↑のfirstコミット~ブランチのheadコミットのdiffをdiffファイルに
  " silent exe '!git diff head~' . commit_num . '..head > ' . pr_diff_file
  " execute 'edit '.pr_diff_file
" endfunction

" " unite.vim で表示される候補を返す
" function! s:source.gather_candidates(args, context)
    " let candidates = []

    " echo('Fetching Pull Requests...')
    " redir => prs
    " silent exe '!curl -s "https://api.github.com/repos/some_repo/pulls?access_token=YOUR_ACCESS_TOKEN&state=open"|jq ".[] | [ .title, .number, .user.login ]"| tr -d "\n"'
    " redir END

    " let prs = split(prs, '[  ')
    " " 最初に余分な要素があるので削除
    " let prs = prs[1:-1]

    " for pr in prs
      " let pr = substitute(pr, ']', '', 'g')
      " let pr = split(pr, ', ')

      " let title = substitute(pr[0], '"', '', 'g')
      " let id = substitute(pr[1], ' ', '', '')
      " let user = substitute(pr[2], '"', '', 'g')
      " let user = substitute(user, ' ', '', '')

      " let candidate_info = {
" \        'word': '#'.id.': '.title. ' (by @' . user . ')',
" \        'action__pr_id': id,
" \        'source': 'pull_requests'
" \      }
      " call add(candidates, candidate_info)
    " endfor

    " return candidates
" endfunction

" " untie.vim に source を登録
" call unite#define_source(s:source)
" unlet s:source
