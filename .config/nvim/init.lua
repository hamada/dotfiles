--**************************************************************
-- TODOs
--**************************************************************
--   - write down all current coc settings
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

-- customize indent
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Search Settings
-- ignore case when you search characters, but don't ignore case when you search upper case.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Hide mached count for search query. because it's displayed in status line.
vim.opt.shortmess:append('S')

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

-- you can see all leader key mappings with `:verbose map <leader>`
vim.g.mapleader = ','

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

-- select all
-- NOTE: wezterm maps ctrl-a to ctrl-` (because nvim can't directly map command key)
vim.keymap.set('n', '<C-`>', 'ggVG', { noremap = true })

-- move page tab
vim.keymap.set('n', 'H', 'gT', { noremap = true })
vim.keymap.set('n', 'L', 'gt', { noremap = true })
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('n', '<C-j>', '`', { noremap = true })
vim.keymap.set('n', '/', "/\\v", { noremap = true })
-- close buffer with q, not :q<enter>
--    if buffer is last(only) one and its content is empty, close it q.
--    ref:
--       - https://github.com/vim-jp/issues/issues/651
--       - https://zenn.dev/sa2knight/articles/e0a1b2ee30e9ec22dea9
vim.keymap.set('n', 'q', ':<C-u>lua _G.QuitbufferIfLastAndEmpty()<CR>', { noremap = true, silent = true })
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

-- terminal related commands
vim.keymap.set('n', '<leader>t', ':MyTermSplit<CR>', { noremap = true })

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
--    - handy plugins: https://www.reddit.com/r/neovim/comments/1azmxiy/underrated_plugins/
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
    init = function()
      vim.g.NERDCreateDefaultMappings = 0 -- disable default mappings
      vim.g.NERDSpaceDelims = 1 -- use spaces after comment delimiters

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
      -- vim.keymap.set('n', ',c', '<Plug>(mkdx-checkbox-next-n)')
      -- vim.keymap.set('v', ',c', '<Plug>(mkdx-checkbox-next-v)')
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
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
        "<leader>F",
        ":Telescope filetypes<CR>",
        { noremap = true }
      )
    end,
  },
  {
    -- for other refs: https://zenn.dev/takuya/articles/4472285edbc132
    -- use forked and locally cloned repo.
    --    - 'nvim-telescope/telescope-file-browser.nvim',
    --    - 'hamada/telescope-file-browser.nvim',
    -- reasons
    --    - I'd like to use absolute path for Picker title.
    --       - https://github.com/hamada/telescope-file-browser.nvim/tree/abs-path-for-result_title
    --    - I'd like to create new file in new tab (defined fb_actions.create_in_new_tab)
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
        "<leader>f",
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
        "<leader>b",
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
    'octarect/telescope-menu.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    init = function()
      require("telescope").setup {
        extensions = {
          menu = {
            default = {
              items = {
                -- You can add an item of menu in the form of { "<display>", "<command>" }
                { "Wrap toggle", "set wrap!" },
                { "CoCDisable", "CocDisable" },
                { "Copilot disable", "Copilot disable" },
                { "Copilot enable", "Copilot enable" },
                { "Checkhealth", "checkhealth" },
                { "Show LSP Info", "LspInfo" },
                { "Files", "Telescope find_files" },
                -- The above examples are syntax-sugars of the following;
                -- { display = "Change colorscheme", value = "Telescope colorscheme" },
              },
            },
          },
        },
      }

      require("telescope").load_extension "menu"
      vim.api.nvim_set_keymap("n", "<leader>m", ":Telescope menu<CR>", { noremap = true, silent = true })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    init = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          -- set true to fix matchit jump by `%` for some ruby (rspec) code.
          -- related issue: https://github.com/neovim/neovim/issues/22089
          additional_vim_regex_highlighting = true
        },
      }
      -- require("vim.treesitter.query").set("ruby", "(class)", "@hoge")

      vim.treesitter.language.register('markdown', 'mdx')
    end
  },
  { 'slim-template/vim-slim' },
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
      vim.cmd('highlight @constant.ruby guifg=#f29b68')
    end
  },
  {
    'nvim-treesitter/playground',
    cond = false,
  },
  {
    'github/copilot.vim',
    -- temporarily disabled because for copilot chat
    -- cond = false,
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
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" }, -- for telescope help actions (optional)
    },
    -- TODO: remove this init function. no longer needed.
    -- because I need to use config function for virtual text settings.
    -- so I migrate all to config function.
    init = function()
      -- ref: https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua
      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          -- vim.opt_local.relativenumber = true
          -- vim.opt_local.number = false

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          -- local ft = vim.bo.filetype
          -- if ft == "copilot-chat" then
            -- vim.bo.filetype = "markdown"
          -- end
        end,
      })

      vim.cmd('autocmd BufEnter * if &filetype == "copilot-chat" || &filetype == "" | setlocal ft=markdown | endif')
    end,
    config = function(_, opts)
      local chat = require("CopilotChat")
      local ns = vim.api.nvim_create_namespace("copilot-chat-text-hl")

      -- ref: https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua
      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function(env)
          vim.opt_local.number = false

          -- Display Header Separator
          -- refs: screenshot of https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/334#issue-2319472872
          vim.api.nvim_create_autocmd({ 'TextChanged', "TextChangedI" }, {
            group = vim.api.nvim_create_augroup('copilot-chat-text-' .. env.buf, { clear = true }),
            buffer = env.buf,
            callback = function()
              vim.api.nvim_buf_clear_namespace(env.buf, ns, 0, -1)
              local lines = vim.api.nvim_buf_get_lines(env.buf, 0, -1, false)
              for l, line in ipairs(lines) do
                if line:match(opts.separator .. "$") then
                  local sep = vim.fn.strwidth(line) - vim.fn.strwidth(opts.separator)
                  local separator_text = "━" -- U+2501. (FYI, U+2500 is thinner than U+2501)
                  vim.api.nvim_buf_set_extmark(env.buf, ns, l - 1, sep, {
                    virt_text_win_col = sep,
                    virt_text = { { string.rep(separator_text, vim.go.columns), "@punctuation.special.markdown" } },
                    priority = 100,
                  })
                  vim.api.nvim_buf_set_extmark(env.buf, ns, l - 1, 0, {
                    end_col = sep + 1,
                    hl_group = "@markup.heading.2.markdown",
                    priority = 100,
                  })
                end
              end
            end,
          })
        end,
      })

      chat.setup(opts)
    end,
    opts = {
      --system_prompt = prompts.COPILOT_INSTRUCTIONS, -- System prompt to use
      model = 'gpt-4', -- GPT model to use
      temperature = 0.1, -- GPT temperature
      debug = false, -- Enable debug logging
      show_user_selection = false, -- Shows user selection in chat
      show_system_prompt = false, -- Shows system prompt in chat
      show_folds = true, -- Shows folds for sections in chat
      show_help = false, -- Shows help message as virtual lines when waiting for user input
      clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
      auto_follow_cursor = true, -- Auto-follow cursor in chat
      question_header = " User ", -- icon is nf-fa-user of nerd font. (technically, font is Hack Nerd Font.)
      answer_header = " Copilot ", -- icon is nf-oct-copilot of nerd font. I don't know why but nf-oct-copilot icon doesn't work. (technically, font is Hack Nerd Font.)
      error_header = " Error ", -- icon is nf-oct-alert of nerd font. (technically, font is Hack Nerd Font.)
      separator = "───", -- Separator to use in chat
      highlight_selection = false, -- disable highlighting selection in the source buffer when in the chat window
      mappings = {
        -- close = "q", -- Close chat (default)
        reset = { normal ='<C-r>' }, -- Clear the chat buffer
        complete = { insert = "<C-c>" }, -- change from default setting. because I'd like to use <Tab> for github/copilot.vim
        submit_prompt = { normal = "<CR>", insert = "<S-CR>" }, -- Submit question to Copilot Chat
        -- accept_diff = "<C-a>", -- Accept the diff (default)
        -- show_diff = "<C-s>", -- Show the diff (default)
      },
      prompts = { -- Favorite Prompts
        ExplainInJapanese = 'Explain how this code works in Japanese.',
        Explain = 'Explain how this code works.',
        Review = 'Review the following code and provide concise suggestions.',
        ReviewInJapanese = 'Review the following code and provide concise suggestions in Japanese.',
        Tests = "Please explain how the selected code works, then generate unit tests for it.",
        Refactor = "Please refactor the following code to improve its clarity and readability.",
        -- Text-related prompts.
        TranslateToJapanese = 'Translate it into Japanese',
        TranslateToEnglish = 'Translate it into English',
        Summarize = "Please summarize the following text.",
        Spelling = "Please correct any grammar and spelling errors in the following text.",
        Wording = "Please improve the grammar and wording of the following text.",
        Concise = "Please rewrite the following text to make it more concise.",
      }
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
    keys = {
      {
        "<leader>c",
        mode = "n",
        -- function()
          -- local input = vim.fn.input("CopilotChat: ")
          -- if input ~= "" then
            -- vim.cmd("CopilotChat " .. input)
          -- end
        -- end,
        function()
          require("CopilotChat").open({
            selection = require("CopilotChat.select").buffer,
            -- window = {
              -- layout = 'float',
              -- title = 'My Title',
            -- },
          })
          vim.cmd('startinsert')
        end,
        desc = "CopilotChat - vsplit prompt",
      },
      {
        "<leader>v",
        mode = "n",
        function()
          local prompt_actions_for_buffer = require("CopilotChat.actions").prompt_actions({ selection = require("CopilotChat.select").buffer })
          require("CopilotChat.integrations.telescope").pick(prompt_actions_for_buffer)
        end,
        desc = "CopilotChat - prompt actions",
      },
      {
        "<leader>v",
        mode = "x",
        function()
          local prompt_actions_for_visually_selected = require("CopilotChat.actions").prompt_actions({ selection = require('CopilotChat.select').visual })
          require('CopilotChat.integrations.telescope').pick(prompt_actions_for_visually_selected)
        end,
        desc = "CopilotChat - prompt actions",
      },
      {
        "<C-i>",
        mode = "n",
        function()
          require("CopilotChat").open({
            -- selection = require("CopilotChat.select").line, -- default
            window = {
              layout = 'float',
              relative = 'cursor',
              border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
              width = 1,
              height = 0.4,
              row = 1
            },
          })
          vim.cmd('startinsert')
        end,
        desc = "CopilotChat - inline prompt",
      },
    },
  },
  {
    'ixru/nvim-markdown',
    init = function()
      -- vim.g.vim_markdown_no_default_key_mappings = true
      -- change keymapping of Markdown_FollowLink in normal mode (default is <CR>)
      vim.cmd "map <S-CR> <Plug>Markdown_FollowLink"
      -- change keymapping of Markdown_CreateLink in visual mode (default is <C-k>)
      vim.cmd "map <C-l> <Plug>Markdown_CreateLink"

      -- disable keymapping for this function
      vim.cmd "map <Plug> <Plug>Markdown_Fold"
    end

  },
  {
    -- markdown preview
    'MeanderingProgrammer/markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('render-markdown').setup({
          -- Characters that will replace the # at the start of headings
          headings = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
        })
    end,
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
      -- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
      -- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


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
      -- keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


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
      -- vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

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
    -- right top corner file name for panes plugin
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
  {
    -- status customization plugin
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {
            {
              'mode',
              -- on_click = function()
                -- require("CopilotChat").open({
                  -- selection = require("CopilotChat.select").buffer,
                  -- -- window = {
                  -- -- layout = 'float',
                  -- -- title = 'My Title',
                  -- -- },
                -- })
                -- vim.cmd('startinsert')
              -- end
            }
          },
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {
            {
              'filename',
              path = 3,
              symbols = {
                readonly = '[ReadOnly]', -- Text to show when the file is non-modifiable or readonly.
              }
            },
          },
          lualine_x = {'filetype', 'encoding', 'fileformat',},
          lualine_y = {
            'location',
            'progress',
            {
              'searchcount',
              maxcount = 999,
              timeout = 500,
            },
          },
          lualine_z = {
            {
              'Copilot Chat Icon',
              color = { fg = '', bg = '', gui='' },
              section_separators = { left = '', right = '' },
              fmt = function(context)
                return ' '
                -- Show + if buffer is modified in tab
                -- local buflist = vim.fn.tabpagebuflist(context.tabnr)
                -- local winnr = vim.fn.tabpagewinnr(context.tabnr)
                -- local bufnr = buflist[winnr]
                -- local mod = vim.fn.getbufvar(bufnr, '&mod')

                -- return name .. (mod == 1 and ' +' or '')
              end,
              on_click = function()
                require("CopilotChat").open({
                  selection = require("CopilotChat.select").buffer,
                })
                vim.cmd('startinsert')
              end
            }
          }
        },
        -- inactive_sections = {
          -- lualine_a = {},
          -- lualine_b = {},
          -- lualine_c = {'filename'},
          -- lualine_x = {'location'},
          -- lualine_y = {},
          -- lualine_z = {}
        -- },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
  -- {
    -- https://www.reddit.com/r/neovim/comments/14f0t0n/comment/joxs498/
  -- },
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

--- *******************************
-- Terminal in Neovim Settings
  -- you can escape from insert mode to normal mode in terminal by `<ESC>`
--  *******************************
vim.cmd([[
" hide line number in terminal
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal nonumber
" open terminal with insert mode
autocmd TermOpen * startinsert
" open terminal in split window
command! -nargs=* MyTermSplit split | wincmd j | resize 20 | terminal <args>
]])

-- *******************************
-- function for keymapping of q
-- *******************************
function _G:QuitbufferIfLastAndEmpty()
  if BufferIsLastOne() and CurrentBufferIsEmptyInLua() then
    vim.cmd("q")
  else
    local ok, error = pcall(vim.cmd, 'bd')
    if not ok then
      -- `error` is like below before gsub. get only `EXX: ~` part.
      -- `vim/_editor.lua:0: nvim_exec2(): Vim(bdelete):E89: No write since last change for buffer 1 (add ! to override)`
      replaced_error, count = string.gsub(error, "(.+):(E%d+.+)$", "%2")
      vim.api.nvim_echo({{replaced_error, 'ErrorMsg'}}, true, {})
    end
  end
end

function _G:BufferIsLastOne()
  local max_buffer_number = vim.fn.bufnr('$')
  local buffers = vim.fn.range(1, max_buffer_number)
  -- local buffers = vim.api.nvim_list_bufs()

  -- print('max_buffer_number: ' .. max_buffer_number)
  -- print('---')

  local count = 0
  for _, buffer_number in ipairs(buffers) do
    -- print(buffer_number)
    if vim.api.nvim_buf_is_loaded(buffer_number) then
      local bufname = vim.fn.bufname(buffer_number)

      -- print('buffer: { ' .. 'number: ' .. buffer_number .. ', bufname: ' .. bufname .. ' }')

      if not(bufname == 'copilot-chat') and not(bufname == '') then
        count = count + 1
      end
    end
  end

  -- print('buffer_count: ' .. count)
  return count <= 1
end

function _G.CurrentBufferIsEmptyInLua()
  -- ファイルの内容が空
  local line_count = vim.fn.line('$')
  local content_of_first_line = vim.fn.getline(1)
  if line_count == 1 and content_of_first_line == '' then
    -- ファイル名が空ならtrue
    return vim.fn.expand('%:t') == ''
  else
    return false
  end
end
