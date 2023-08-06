--**************************************************************
-- TODOs
--**************************************************************
--   - add symbolic links for neovim files without using cp
--   - write down all current coc settings
--   - regex match for (file browser) telescope
--   - order telescope file browser results by directory first, Capital letter file, then lower letter file.
--     - hide dotfiles in default if I can. (but I can search it when I type dot)
--   - save and store reference docs, pages and articles related to my settings
--   - after commiting .config/nvim/init.lua, remove comments out code and clean up
--   - migrate IME ruby remote plugin script to bash or lua script (not use ruby)
--**************************************************************

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
--
--  About lua
--    refs
--      - https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
--      - https://zenn.dev/hisasann/articles/neovim-settings-to-lua
--      - https://zenn.dev/slin/articles/2020-11-03-neovim-lua2
--      - https://riq0h.jp/2023/01/20/210601/
--      - https://uhoho.hatenablog.jp/entry/2023/05/18/063603
--      - https://joker1007.hatenablog.com/entry/2022/09/03/172957
--  About My Nvim env
--    - GUI like standalone app based on Wezterm
--       - neovim is running with server settings
--    - IME settings
--       - karabiner elements (override 英数/かな key push, then run to communicate to nvim)
--       - ruby script communicates to nvim
--       - macism CLI command
--    - My Own Telescope Settings
--       - Bookmark Picker
--       - Forked File Browser
--**************************************************************

--**************************************************************
-- Basic Settings
--**************************************************************
vim.opt.title = true
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
-- FIXME: if true, this creates weird files. so disable temporarily
vim.opt.swapfile = false
-- vim.opt.directory = '$HOME/.neovim/swap'
-- backup files
-- FIXME: if true, this creates weird files. so disable temporarily
vim.opt.backup = false
-- vim.opt.backupdir = '$HOME/.neovim/backup'

-- vertical split right everytime
vim.opt.splitright = true

vim.opt.autochdir = true

-- show matched count when search with /, ? or *
vim.opt.shortmess = vim.opt.shortmess - 'S'

-- to prevennt to automatically fold code when you open a file
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.opt.foldlevel = 99

-- if you yank words, it's shared with clipboard
vim.opt.clipboard = 'unnamed'

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

-- set filetype mdx for .mdx file
vim.filetype.add({ extension = { mdx = 'mdx' } })
--********************************************************************************************
-- Theme Related Settings
--********************************************************************************************

vim.opt.guifont = 'Hack Nerd Font bold:h13'
vim.api.nvim_create_user_command("ResetFont", function(opts)
  vim.cmd("set guifont=Hack Nerd Font bold:h13")
end, {})
-- vim.api.nvim_create_user_command("ResetFont", function(opts)
--   vim.cmd("set guifont=Ricty Diminished bold:h14")
-- end, {})

-- OPTIMIZE: convert this into lua style
vim.cmd("set guioptions-=e") -- use tabline

-- OPTIMIZE: convert this into lua style
vim.cmd([[
set tabline=%!MakeTabLine()

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
-- wezterm maps shift-space to ctrl-space
vim.keymap.set('n', '<C-SPACE>', '<PageUp>zz', { noremap = true })
vim.keymap.set('i', '<C-SPACE>', ' ', { noremap = true })
-- wezterm maps command-t to ctrl-t (to disable new tab feature of wezter app)
vim.keymap.set('n', '<C-t>', '<ESC>:tabnew<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-e>', ':<C-u>105vs ~/.config/nvim/init.lua<Enter> :se nowrap<Enter>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-s>', ':<C-u>source ~/.config/nvim/init.lua<Enter>', { noremap = true, silent = true })

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
vim.keymap.set('n', 'vs', ':<C-u>vnew<CR>', { noremap = true, silent = true })
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


-- タブを開いた時の元のタブが空の場合閉じる
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

require('lazy').setup({
  -- Plugins List
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
  {
    'numToStr/Comment.nvim',
    cond = false,
    config = function()
      require('Comment').setup()
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
    'SidOfc/mkdx',
    cond = false,
    init = function()
      -- change keymapping for toggling checkbox
      vim.keymap.set('n', ',c', '<Plug>(mkdx-checkbox-next-n)')
      vim.keymap.set('v', ',c', '<Plug>(mkdx-checkbox-next-v)')
    end
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
    end,
  },
  {
    -- for other refs: https://zenn.dev/takuya/articles/4472285edbc132
    -- 'nvim-telescope/telescope-file-browser.nvim',
    -- 'hamada/telescope-file-browser.nvim',
    -- use forked and locally cloned repo. Because use absolute path for Picker title.
    dir = '~/code/lua/telescope-file-browser.nvim',
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

      local telescope_actions = require('telescope.actions')
      local fb_actions = require "telescope".extensions.file_browser.actions
      require("telescope").setup {
        extensions = {
          file_browser = {
            path="%:p:h",
            hidden = true,
            display_stat = false,
            hide_parent_dir = true,
            hijack_netrw = true,
            -- results_title = function(a, b)
              -- if true then
                -- 'this is true'
              -- else
                -- 'this is false'
              -- end
            -- end,
            -- results_title = 'hoge',
            -- results_title = 'hoge',
            file_ignore_patterns = {".DS_Store", ".Trash", ".CFUserTextEncoding"},
            mappings = {
              n = {
                ["<CR>"] = function(prompt_bufnr, bypass)
                  telescope_actions.select_tab(prompt_bufnr, bypass)

                  local entry_path = require("telescope.actions.state").get_selected_entry().Path
                  if entry_path:is_dir() then
                    vim.cmd('startinsert')
                  else
                    -- not sure why. but cursor is on 2nd column in 1st line.
                    -- so move cursor to left.
                    vim.cmd('normal! h')
                  end
                end,
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
                     vim.cmd "normal! ddi"
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
    'hamada/telescope-file-bookmarks.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      -- For nvim-web-devicons, did the followings after installing devicons plugin
      --   1. installed font via `$ brew install font-hack-nerd-font`
      --   2. set guifont to `Hack\ Nerd\ Font`
      'nvim-tree/nvim-web-devicons'
    },
    init = function()
      opts = {
        bookmarks_file_path = vim.fn.expand("$HOME/.config/nvim/.telescope_vim_bookmarks.json")
      }

      vim.api.nvim_set_keymap(
        "n",
        ",b",
        ":lua require('telescope-file-bookmarks').run(opts)<CR>",
        { noremap = true, silent = true }
      )

      -- require("telescope").load_extension "file_bookmarks"
    end
  },
  {
    'hamada/telescope-file-myown-sorter.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    init = function()
      require("telescope").load_extension "file-myown-sorter"
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    init = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true, },
      }
      -- require("vim.treesitter.query").set("ruby", "(class)", "@hoge")

      vim.treesitter.language.register('markdown', 'mdx')
    end
  },
  {
    'sainnhe/sonokai',
    config = function()
      vim.g.sonokai_better_performance = 1
      vim.cmd('colorscheme sonokai')

      -- Settings for Ruby Code Colors
      -- refs
      --   - https://zenn.dev/vim_jp/articles/2022-12-25-vim-nvim-treesitter-2022-changes
      --   - https://github.com/sainnhe/sonokai/blob/adb066ac5250556ccfca22f901c9710a735f23c2/colors/sonokai.vim#L2388-L2398
      --   - https://zenn.dev/monaqa/articles/2021-12-22-vim-nvim-treesitter-highlight
      --   - https://blog.atusy.net/2023/04/19/tsnode-marker-nvim/
      --   - https://www.reddit.com/r/neovim/comments/m8zedt/how_to_change_a_particular_syntax_token_highlight/
      --   - https://github.com/nvim-treesitter/nvim-treesitter#highlight

      -- vim.cmd('highlight @text.title.1.markdown guifg=Purple')
      vim.cmd('highlight @symbol.ruby guifg=SkyBlue')
      vim.cmd('highlight @operator.ruby guifg=#e2e2e3')
      vim.cmd('highlight @type.ruby guifg=#f29b68')
    end
  },
  {
    'nvim-treesitter/playground',
    cond = false,
  },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- NOTE: you have to install node and `npm install --global neovim`
      -- NOTE: g:node_host_prog doesn't work. use `g:copilot_node_command`
      --       ref: https://github.com/orgs/community/discussions/13310#discussioncomment-2511090
      vim.g.copilot_node_command = "~/.nvm/versions/node/v18.16.1/bin/node"
      vim.g.copilot_filetypes = { markdown = true }
    end
  },
  {
    'hrsh7th/vim-vsnip',
    dependencies = { 'hrsh7th/vim-vsnip-integ' },
    event = 'InsertEnter',
    config = function()
      -- snippets are in $HOME/.vsnip/ directory
      -- helpful snippets comes from https://github.com/rafamadriz/friendly-snippets
      vim.g.vsnip_snippet_dir = '~/.config/nvim/vsnip'
      vim.cmd "imap <expr> <C-k> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-k>'"
    end
  },
  {
    -- config of coc.nvim is in `~/.config/nvim/coc-settings.json`
    'neoclide/coc.nvim',
    -- cond = false,
    branch = 'release',
    init = function()
      -- do the following after installing coc.nvim via lazy.nvim. you need install yarn dependencies of coc.nvim
      --   (you can find out coc.nvim directory by :Lazy command in neovim, and select coc.nvim in lazy.nvim UI)
      --  `$ cd ~/.local/share/nvim/lazy/coc.nvim`
      --  `$ nvm use v18.16.1`
      --  `$ npm install -g yarn`
      --  `$ yarn install`
      vim.g.coc_node_path = '~/.nvm/versions/node/v18.16.1/bin/node'
    end,
    config = function()
      -- Some servers have issues with backup files, see #649
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
      -- delays and poor user experience
      vim.opt.updatetime = 300

      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appeared/became resolved
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set
      -- Autocomplete
      function _G.check_back_space()
          local col = vim.fn.col('.') - 1
          return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-j> to trigger snippets
      keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
      -- Use <c-space> to trigger completion
      keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
      keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
      keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
      keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


      -- Use K to show documentation in preview window
      function _G.show_docs()
          local cw = vim.fn.expand('<cword>')
          if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
              vim.api.nvim_command('h ' .. cw)
          elseif vim.api.nvim_eval('coc#rpc#ready()') then
              vim.fn.CocActionAsync('doHover')
          else
              vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
          end
      end
      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
          group = "CocGroup",
          command = "silent call CocActionAsync('highlight')",
          desc = "Highlight symbol under cursor on CursorHold"
      })


      -- Symbol renaming
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


      -- Formatting selected code
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
          group = "CocGroup",
          pattern = "typescript,json",
          command = "setl formatexpr=CocAction('formatSelected')",
          desc = "Setup formatexpr specified filetype(s)."
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
          group = "CocGroup",
          pattern = "CocJumpPlaceholder",
          command = "call CocActionAsync('showSignatureHelp')",
          desc = "Update signature help on jump placeholder"
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = {silent = true, nowait = true}
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply source code actions for current file.
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = {silent = true, nowait = true, expr = true}
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset("i", "<C-f>",
             'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset("i", "<C-b>",
             'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      -- this conflicts with other keybindings. so, disable this temporarily.
      -- keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      -- NOTE: Please see `:h coc-status` for integrations with external plugins that
      -- provide custom statusline: lightline.vim, vim-airline
      vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

      -- Mappings for CoCList
      -- code actions and coc stuff
      ---@diagnostic disable-next-line: redefined-local
      local opts = {silent = true, nowait = true}
      -- OPTIMIZE: temporarily disabled, because <space> conflicts with other keymap
      -- Show all diagnostics
      -- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
      -- -- Manage extensions
      -- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
      -- -- Show commands
      -- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
      -- -- Find symbol of current document
      -- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
      -- -- Search workspace symbols
      -- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
      -- -- Do default action for next item
      -- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
      -- -- Do default action for previous item
      -- keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
      -- -- Resume latest coc list
      -- keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
    end
  },
  {
    'folke/noice.nvim',
    cond = false,
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    init = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
  },
  {
    'akira-hamada/friendly-grep.vim',
    config = function()
      vim.keymap.set('n', '<C-g>', '<ESC>:FriendlyGrep<CR>', { noremap = true })

      vim.keymap.set('n', '<LEFT>', ':cprevious<CR>', { noremap = true })
      vim.keymap.set('n', '<RIGHT>', ':cnext<CR>', { noremap = true })
      vim.keymap.set('n', '<UP>', ':<C-u>cfirst<CR>', { noremap = true })
      vim.keymap.set('n', '<DOWN>', ':<C-u>clast<CR>', { noremap = true })

      -- let g:friendlygrep_target_dir = join(readfile(glob('~/dotfiles/.vim/friendly_grep_search_root_path')), "\n")
      vim.g.friendlygrep_recursively = 1
      vim.g.friendlygrep_display_result_in = 'tab'
    end
  }
})

-- ***********************************************************************************************
-- IME Manupilation
-- refs
--   - https://github.com/laishulu/macism/
--   - https://qiita.com/callmekohei/items/343f09c619665a5c9886
--   - http://iranoan.my.coocan.jp/essay/pc/201810080.htm
-- ***********************************************************************************************

-- `:lua IsIMEIsActivated()` to get current input method status
function _G.IsIMEIsActivated()
  local imstate = vim.fn.system('/opt/homebrew/bin/macism')
  if string.find(imstate, "Roman") then
    return 0 -- not ja
  else
    return 1 -- ja
  end
end

function _G:DeactivateIME()
  vim.fn.system('/opt/homebrew/bin/macism com.google.inputmethod.Japanese.Roman')
end


vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.cmd([[
      highlight Cursor gui=NONE guibg=Khaki
      highlight ICursor gui=NONE guibg=Khaki
    ]])
    DeactivateIME()
  end
})

vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    DeactivateIME()
  end
})

-- My own events to switch color based on IME state.
-- You can activate these my own Event (ref: https://github.com/vim-jp/issues/issues/142)
  -- `:doautocmd User ImeDeactivated`
  -- `:doautocmd User ImeActivated`
-- My own Ruby Script publish this event based on IME state by karabinar elements
vim.cmd([[
autocmd User ImeDeactivated highlight Cursor gui=NONE guibg=Khaki   | highlight ICursor gui=NONE guibg=Khaki
autocmd User ImeActivated   highlight Cursor gui=NONE guibg=SkyBlue | highlight ICursor gui=NONE guibg=SkyBlue
]])
-- ***********************************************************************************************


-- ***********************************************************************************************
-- Color Settings
--
-- NOTE: settings for the followings are in wezterm config
--   default cursor color (Cursor in command mode, visual mode)
--   font color while inputting japanese text (before determined)
--   background color while inputting japanese text (before determined)
--   thickness of the cursor while insert mode (vertical bar)
-- ***********************************************************************************************
vim.opt.termguicolors = true
-- there's blink setting in wezterm config too.
vim.opt.guicursor='n:block-Cursor-blinkwait5-blinkon5-blinkoff5,i-ci:ver100-ICursor-blinkwait5-blinkon5-blinkoff5'

-- settings for Cursor Color
vim.cmd('highlight  Cursor gui=NONE guibg=khaki')
vim.cmd('highlight ICursor gui=NONE guibg=khaki')
vim.cmd('highlight CursorLine gui=NONE guibg=#242424')

vim.cmd('highlight Visual gui=NONE guifg=khaki guibg=olivedrab') -- settings for Visual mode Line Color (not cursor of visual mode)
vim.cmd('highlight Folded guifg=#e7c664 guibg=#212121') -- Folded Text Color
vim.cmd('highlight TabLineSel guibg=#e2e2e3') -- Selected Tab Background Color
