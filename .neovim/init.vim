"-------------------------------
" Memo
" ------------------------------
"  About Nvim
"    ref: https://qiita.com/powdersugar828828/items/f31ca3bd28d3163fae6a
"
"  About VimR
"    I use neovim through VimR. VimR is easy to setup for GUI App.
"
"    Official: https://github.com/qvacua/vimr
"    ref: 
"      - https://applech2.com/archives/20211107-vimr-neovim-gui-for-macos-in-swift-support-apple-silicon.html
"      - https://applech2.com/archives/20211107-vimr-neovim-gui-for-macos-in-swift-support-apple-silicon.html
"--------------------------------------------------------------------------------------------
" Basic Settings
"--------------------------------------------------------------------------------------------
set fenc=utf-8
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

"--------------------------------------------------------------------------------------------
" Customize Statusline
"--------------------------------------------------------------------------------------------
set laststatus=2
"set statusline=%1*%F%m%r%h%w%*\ [filetype:\ %Y]\ [fenc:\ %{&fenc}]\ [enc:\ %{&enc}]\ [ff:\ %{&ff}]\ %2*%{fugitive#statusline()}%*%=%c,%l%11p%%
hi User1 guifg=#000080 guibg=#c2bfa5
hi User2 guifg=#990000 guibg=#c2bfa5
" use this variable later
let my_own_statusline_format = '%F%m%r%h%w\ [filetype:\ %Y]\ [fenc:\ %{&fenc}]\ [enc:\ %{&enc}]\ [ff:\ %{&ff}]\ %=%c,%l%11p%%'
execute 'set statusline='.my_own_statusline_format

" customize indent
set autoindent
set nosmartindent
set tabstop=4
set shiftwidth=4

" Search Settings
" ignore case when you search characters, but don't ignore case when you search upper case.
set ignorecase smartcase
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set mouse=a
" swap files
set swapfile
set directory=~/.neovim/swap
" backup files
set backup
set backupdir=~/.neovim/backup

set splitright " vertical split right everytime

set autochdir

" show matched count when search with /, ? or *
set shortmess-=S

" to prevennt to automatically fold code when you open a file
" https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
set foldlevel=99

" customoize fold text style
set foldtext=getline(v:foldstart)

" if you yank words, it's shared with clipboard
set clipboard=unnamed
" when IME enabled, set cursor following color
highlight CursorIM guibg=skyBlue guifg=NONE
" 挿入モード・検索モードでのデフォルトのIME状態設定
set iminsert=0 imsearch=0
" 挿入モードでのIME状態を記憶させない
inoremap <silent> <ESC><ESC>:set iminsert=0<CR>
set noimdisable

autocmd BufEnter * if &filetype == "project" || &filetype == "" | setlocal ft=markdown | endif
"--------------------------------------------------------------------------------------------
" Theme Related Settings
"--------------------------------------------------------------------------------------------

" color schema is in .config/nvim/colors/desert.vim 
" colorscheme desert

set guifont=Hack\ Nerd\ Font\ bold:h13
command! ResetFont :set guifont=Hack\ Nerd\ Font\ bold:h13
" set guifont=Ricty\ Diminished\ bold:h14
" command! ResetFont :set guifont=Ricty\ Diminished\ bold:h14

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

"--------------------------------------------------------------------------------------------
" Key Mappings
"--------------------------------------------------------------------------------------------

" double <Esc> clears search highlight
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
noremap ; :
noremap : ;
nnoremap <SPACE> <PageDown>zz
" Karabinar elements changes shift-space to command-space
"   because neovim can't accept shift-space directly
"   FIXME: this doesn't work because of https://stackoverflow.com/questions/279959/how-can-i-make-shiftspacebar-page-up-in-vim
"   ref: about karabinar elements https://qiita.com/yohm/items/de35f3874fd0e679ccdf
nnoremap <D-SPACE> <PageUp>zz

nnoremap <C-e> :<C-u>tabnew ~/.config/nvim/init.vim<Enter> :se nowrap<Enter>:<C-u>90vs ~/.neovim/.dein.toml<Enter> :se nowrap<Enter>
nnoremap <C-s> :<C-u>source ~/.config/nvim/init.vim<Enter>

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
" help settings
nnoremap ? :vertical h 

" move between vsplit windows
noremap <TAB> <C-w>w
noremap <C-TAB> <C-w>W
" Auto Complete
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
" don't register character deleted with x
nnoremap x "_x

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

" ---------------------------------------------------------------------------------------
" dein.vim installation
" ---------------------------------------------------------------------------------------
let $CACHE = expand('~/.neovim/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    " install plugins on repos/ dir of this directory
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " 管理するプラグインを記述したファイル
  let s:toml = '~/.neovim/.dein.toml'
  " let s:lazy_toml = '~/.neovim/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  " call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif
" プラグインの追加・削除やtomlファイルの設定を変更した後は
" 適宜 call dein#update() や call dein#clear_state() を呼んでください。
" そもそもキャッシュしなくて良いならload_state/save_stateを呼ばないようにしてください。
" ref: https://qiita.com/okamos/items/2259d5c770d51b88d75b

" 各プラグインのインストールチェック（なかったら自動的に追加される）
" ref: https://sy-base.com/myrobotics/vim/dein/
if dein#check_install()
  call dein#install()
endif
" ---------------------------------------------------------------------------------------

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

" Settings for Github Copilot
"--------------------------------------------------------------------------------------------
" NOTE: you have to install node and `npm install --global neovim`
" NOTE: if you write this on .dein.toml, it doesn't work. that's why I write here.
" NOTE: g:node_host_prog doesn't work. use `g:copilot_node_command`
"       ref: https://github.com/orgs/community/discussions/13310#discussioncomment-2511090
let g:copilot_node_command = "/Users/akira/.nvm/versions/node/v18.16.1/bin/node"
"--------------------------------------------------------------------------------------------
