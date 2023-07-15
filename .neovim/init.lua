-- init.lua for migration

--**************************************************************
-- Memo
--**************************************************************
--  About Nvim
--    ref: https://qiita.com/powdersugar828828/items/f31ca3bd28d3163fae6a
--
--  About VimR
--    I use neovim through VimR. VimR is easy to setup for GUI App.
--
--    Official: https://github.com/qvacua/vimr
--    ref: 
--      - https://applech2.com/archives/20211107-vimr-neovim-gui-for-macos-in-swift-support-apple-silicon.html
--      - https://applech2.com/archives/20211107-vimr-neovim-gui-for-macos-in-swift-support-apple-silicon.html
--**************************************************************
-- Basic Settings
--**************************************************************
vim.opt.fenc = 'utf-8'
vim.opt.number = true
vim.opt.ruler = true
vim.opt.cursorline = true
-- highlight current cursorline only active window
--   OPTIMIZE: convert this into lua style
vim.cmd([[
augroup vimrc_set_cursorline_only_active_window
  autocmd!
  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline cursorcolumn
  autocmd WinLeave * setlocal nocursorline nocursorcolumn
augroup END
]])
-- augroup vimrc_set_cursorline_only_active_window
--   autocmd!
--   autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline cursorcolumn
--   autocmd WinLeave * setlocal nocursorline nocursorcolumn
-- augroup END
vim.opt.wrap = true
vim.opt.scrolloff = 10

--********************************************************************************************
-- Customize Statusline
--********************************************************************************************
vim.opt.laststatus = 2
vim.g.my_own_statusline_format = "%F%m%r%h%w [filetype: %Y] [fenc: %{&fenc}] [enc: %{&enc}] [ff: %{&ff}] %=%c,%l%11p%%"
vim.opt.statusline = vim.g.my_own_statusline_format

-- customize indent
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Search Settings
-- ignore case when you search characters, but don't ignore case when you search upper case.
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = 'tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%'
vim.opt.mouse = 'a'
-- swap files
vim.opt.swapfile = true
vim.opt.directory = '~/.neovim/swap'
-- backup files
vim.opt.backup = true
vim.opt.backupdir = '~/.neovim/backup'

-- vertical split right everytime
vim.opt.splitright = true

vim.opt.autochdir = true

-- show matched count when search with /, ? or *
vim.opt.shortmess = vim.opt.shortmess - 'S'

-- to prevennt to automatically fold code when you open a file
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.opt.foldlevel = 99

-- customoize fold text style
--   OPTIMIZE: convert this to lua style
--   this doesn't work
--   vim.opt.foldtext = getline(v:foldstart)
vim.cmd("set foldtext=getline(v:foldstart)")

-- if you yank words, it's shared with clipboard
vim.opt.clipboard = 'unnamed'
-- when IME enabled, set cursor following color
-- FIXME: this doesn't work with neovim
-- highlight CursorIM guibg=skyBlue guifg=NONE
-- 挿入モード・検索モードでのデフォルトのIME状態設定
vim.opt.iminsert = 0
vim.opt.imsearch = 0
-- 挿入モードでのIME状態を記憶させない
vim.keymap.set('i', '<ESC><ESC>', ':set iminsert=0<CR>', { noremap = true, silent = true })
vim.opt.imdisable = false

-- OPTIMIZE: convert this into lua style
vim.cmd('autocmd BufEnter * if &filetype == "project" || &filetype == "" | setlocal ft=markdown | endif')
--  refs
--    - https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md#%E3%82%AA%E3%83%BC%E3%83%88%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%82%92%E5%AE%9A%E7%BE%A9%E3%81%99%E3%82%8B
--    - https://zenn.dev/slin/articles/2020-11-03-neovim-lua2#autocmd
--    - https://uhoho.hatenablog.jp/entry/2023/05/18/063603
--    - https://scrapbox.io/vimemo/autocmd_%E3%81%A7_if_%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E6%9D%A1%E4%BB%B6%E5%88%86%E5%B2%90
--    - https://dev.classmethod.jp/articles/eetann-okorare-neovim/
--    - https://qiita.com/s_of_p/items/b61e4c3a0c7ee279848a
-- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--   pattern = '* if &filetype == "project" || &filetype == ""',
--   command = 'setlocal ft=markdown',
-- })

--********************************************************************************************
-- Theme Related Settings
--********************************************************************************************

-- color schema is in .config/nvim/colors/desert.vim 
-- vim.cmd('colorscheme desert')

vim.opt.guifont = 'Hack Nerd Font bold:h13'
vim.api.nvim_create_user_command("ResetFont", function(opts)
  vim.cmd("set guifont=Hack Nerd Font bold:h13")
end, {})
-- vim.opt.guifont = 'Ricty Diminished bold:h14'
-- vim.api.nvim_create_user_command("ResetFont", function(opts)
--   vim.cmd("set guifont=Ricty Diminished bold:h14")
-- end, {})

-- OPTIMIZE: convert this into lua style
vim.cmd("set guioptions-=e") -- use tabline

-- OPTIMIZE: convert this into lua style
vim.cmd([[
set tabline=%!MakeTabLine()
hi TabLineSel ctermfg=Black ctermbg=White guifg=Black guibg=White
hi TabLine ctermfg=Black ctermfg=Gray ctermbg=black guifg=White guibg=grey21
hi TabLineFill ctermbg=black guifg=grey8

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

function! MakeTabLine() "{{{
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ' '  " タブ間の区切り
  let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
  let info = ''  " 好きな情報を入れる
  return tabpages . '%=' . info  " タブリストを左に、情報を右に表示
endfunction "}}}

]])

--********************************************************************************************
-- Key Mappings
--********************************************************************************************

-- double <Esc> clears search highlight
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR><Esc>', { noremap = true })
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', ':', ';', { noremap = true })
vim.keymap.set('n', '<SPACE>', '<PageDown>zz', { noremap = true })
-- Karabinar elements changes shift-space to command-space
--   because neovim can't accept shift-space directly
--   FIXME: this doesn't work because of https://stackoverflow.com/questions/279959/how-can-i-make-shiftspacebar-page-up-in-vim
--   ref: about karabinar elements https://qiita.com/yohm/items/de35f3874fd0e679ccdf
vim.keymap.set('n', '<D-SPACE>', '<PageUp>zz', { noremap = true })

-- OPTIMIZE: convert these into lua style. I don't know why but these doesn't work
vim.cmd("nnoremap <C-e> :<C-u>tabnew ~/.config/nvim/init.lua<Enter> :se nowrap<Enter>:<C-u>90vs ~/.neovim/.dein.toml<Enter> :se nowrap<Enter>")
vim.cmd("nnoremap <C-s> :<C-u>source ~/.config/nvim/init.lua<Enter>")
-- vim.keymap.set('n', '<C-e>', '<C-u>tabnew ~/.config/nvim/init.lua<Enter> :se nowrap<Enter>:<C-u>90vs ~/.neovim/.dein.toml<Enter> :se nowrap<Enter>', { noremap = true })
-- vim.keymap.set('n', '<C-s>', '<C-u>source ~/.config/nvim/init.lua<Enter>', { noremap = true })

-- move page tab
vim.keymap.set('n', 'H', 'gT', { noremap = true })
vim.keymap.set('n', 'L', 'gt', { noremap = true })
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('n', '<C-j>', '`', { noremap = true })
vim.keymap.set('n', '/', "/\\v", { noremap = true })
-- close buffer with q, not :q<enter>
vim.keymap.set('n', 'q', ':<C-u>q<CR>', { noremap = true })
-- record macro with Q, not q
vim.keymap.set('n', 'Q', 'q', { noremap = true })
-- help settings
vim.keymap.set('n', '?', ':vertical h ', { noremap = true })

-- move between vsplit windows
vim.keymap.set('n', '<TAB>', '<C-w>w', { noremap = true })
vim.keymap.set('n', '<C-TAB>', '<C-w>W', { noremap = true })
-- Auto Complete
vim.keymap.set('i', '{', '{}<LEFT>', { noremap = true })
vim.keymap.set('i', '[', '[]<LEFT>', { noremap = true })
vim.keymap.set('i', '(', '()<LEFT>', { noremap = true })
vim.keymap.set('i', "'", "''<LEFT>", { noremap = true })
vim.keymap.set('i', '"', '""<LEFT>', { noremap = true })
-- don't register character deleted with x
vim.keymap.set('n', 'x', '"_x', { noremap = true })

-- open new vsplit window
vim.keymap.set('n', 'vs', ':<C-u>vnew<CR>', { noremap = true })
vim.keymap.set('n', 'vS', ':<C-u>vsplit<CR>', { noremap = true })
vim.keymap.set('n', '<C-h>', ":call ShiftVbar('left', 5)<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', ":call ShiftVbar('right', 5)<CR>", { noremap = true, silent = true })
vim.cmd([[
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
]])

-- matchit.vimを有効化
vim.cmd("source $VIMRUNTIME/macros/matchit.vim")


-- タブを開いた時の元のタブがからの場合閉じる
vim.api.nvim_create_autocmd({ 'TabEnter' }, {
  pattern = '*',
  command = 'call ClosePreviousEmptyTab()',
})

--********************************************************
--  現在のバッファが新規作成で空のバッファの場合1を返す
--     Test it like this
--     echo BufferIsEmpty()
--********************************************************
vim.cmd([[
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
]])

--********************************************************
--  一つ前のタブに移動し空かどうかで以下の処理を行う
--  空: 閉じる
--  何らか入力されている: 元のタブへ移動
--     Test it like this
--     call CloseIfBufferEmpty()
--********************************************************
vim.cmd([[
function! ClosePreviousEmptyTab()
    exe 'normal! gT'
    if BufferIsEmpty() == 1
        exe 'q!'
    else
        exe 'normal! gt'
    endif
endfunction
]])

--****************************************************************
--  lazy.nvim settings (neovim plugin manager)
--  refs
--    - https://github.com/folke/lazy.nvim
--    - https://zenn.dev/euxn23/articles/5e6a25f5583bdc
--****************************************************************
-- Plugin initial install and setups
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  -- Plugins List
  {
    {
      'sainnhe/sonokai',
      config = function()
        vim.g.sonokai_better_performance = 1
        vim.cmd('colorscheme sonokai')
      end
    },
    {
      'chentoast/marks.nvim',
      init = function()
        require'marks'.setup()
      end
    },
    { 'vim-scripts/surround.vim' },
    {
      'vim-scripts/The-NERD-Commenter',
      config = function()
        vim.g.NERDCreateDefaultMappings = 0
        vim.g.NERDSpaceDelims = 1
      end,
      init = function()
        vim.keymap.set('n', '<C-c>', '<Plug>NERDCommenterToggle', { noremap = false })
        vim.keymap.set('v', '<C-c>', '<Plug>NERDCommenterToggle', { noremap = false })
        vim.keymap.set('v', '<C-d>', ':call DupLines()<CR>', { noremap = true, silent = true })
        vim.cmd([[
        " This function depends on NERDCommenter
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
        ]])
      end
    },
    { 'vim-scripts/operator-user' },
    {
      'vim-scripts/operator-replace',
      keys = {
        { "R", "<Plug>(operator-replace)", mode = 'n' },
      },
    },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      dependencies = { 'nvim-lua/plenary.nvim' },
      init = function()
        require('telescope').setup{
          defaults = {
            hidden = true,
            layout_config = { height = 0.9, prompt_position = 'top' },
            sorting_strategy = 'ascending',
            mappings = {
              n = {
                ["q"] = require('telescope.actions').close,
                ["v"] = require('telescope.actions').select_vertical,
              },
            }
          },

          pickers = {
            find_files = {
              mappings = {
                n = {
                  ["<CR>"] = require('telescope.actions').select_tab,
                },
                i = {
                  ["<CR>"] = require('telescope.actions').select_tab,
                },
              },
            },
          }
        }

        vim.api.nvim_set_keymap(
          "n",
          ",F",
          ":Telescope filetypes<CR>",
          { noremap = true }
        )

        vim.api.nvim_set_keymap(
          "n",
          ",b",
          ":luafile /Users/akira/code/lua/telescope_file_bookmarks_picker.lua<CR>",
          { noremap = true }
        )
      end,
    },
    {
      -- for other refs: https://zenn.dev/takuya/articles/4472285edbc132
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = {
        'nvim-telescope/telescope.nvim',
        -- For nvim-web-devicons, did the followings after installing devicons plugin
        --   1. installed font via `$ brew install font-hack-nerd-font`
        --   2. set guifont to `Hack\ Nerd\ Font`
        'nvim-tree/nvim-web-devicons'
      },
      init = function()
        vim.api.nvim_set_keymap(
          "n",
          ",f",
          ":Telescope file_browser path=%:p:h select_buffer=true hidden=true hide_parent_dir=true<CR>",
          { noremap = true }
        )

        local fb_actions = require "telescope".extensions.file_browser.actions
        require("telescope").setup {
          extensions = {
            file_browser = {
              path="%:p:h",
              hidden = true,
              hide_parent_dir = true,
              hijack_netrw = true,
              file_ignore_patterns = {".DS_Store", ".Trash", ".CFUserTextEncoding"},
              mappings = {
                n = {
                  ["<CR>"] = require('telescope.actions').select_tab,
                },
                i = {
                  ["<CR>"] = require('telescope.actions').select_tab,
                  ["<C-h>"] = false,
                  ["<bs>"] = false,
                  -- originally this comes from https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/e03ff55962417b69c85ef41424079bb0580546ba/lua/telescope/_extensions/file_browser/actions.lua#L761
                  -- I customized it.
                  ["<C-w>"] = function(prompt_bufnr, bypass)
                     local action_state = require "telescope.actions.state"
                     local current_picker = action_state.get_current_picker(prompt_bufnr)

                     if current_picker:_get_prompt() == "" then
                       fb_actions.goto_parent_dir(prompt_bufnr, bypass)
                     else
                       -- remove word, keeping insert mode.
                       vim.cmd "normal! ciw"
                     end
                   end,
                }
              },
            },
          },
        }

        require("telescope").load_extension "file_browser"
      end
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ":TSUpdate",
      init = function()
        require('nvim-treesitter.configs').setup {
          highlight = {
            enable = true,
          },
        }
      end
    },
    {
      'github/copilot.vim',
      event = 'InsertEnter',
      config = function()
        -- NOTE: you have to install node and `npm install --global neovim`
        -- NOTE: g:node_host_prog doesn't work. use `g:copilot_node_command`
        --       ref: https://github.com/orgs/community/discussions/13310#discussioncomment-2511090
        vim.g.copilot_node_command = "/Users/akira/.nvm/versions/node/v18.16.1/bin/node"
      end
    },
    {
      'hrsh7th/vim-vsnip',
      dependencies = { 'hrsh7th/vim-vsnip-integ' },
      event = 'InsertEnter',
      config = function()
        -- snippets are in $HOME/.vsnip/ directory
        -- helpful snippets comes from https://github.com/rafamadriz/friendly-snippets
        vim.g.vsnip_snippet_dir = '/Users/akira/.neovim/vsnip'
        vim.cmd "imap <expr> <C-k> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-k>'"
      end
    }
  }
)
