-- config refereces: https://wezfurlong.org/wezterm/config/files.html

local wezterm = require 'wezterm'
local config = {}

-- ************************************************************************************
-- Wezterm Start Up Settings
-- ************************************************************************************
-- I use wezterm only for neovim
config.default_prog = { '/opt/homebrew/bin/nvim', '--listen', 'localhost:22222' }
-- you can handle this nvim from other process like these.
  -- $ nvim --server localhost:22222 --remote-send "hoge"
  -- $ nvim --server localhost:22222 --remote-send "<ESC>;highlight ICursor guibg=SkyBlue<CR>a"

config.quit_when_all_windows_are_closed = false

-- ************************************************************************************
-- Window Settings
-- ************************************************************************************
config.enable_tab_bar = false
config.initial_cols = 180
config.initial_rows = 55
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

-- ************************************************************************************
-- Font Settings
-- ************************************************************************************
-- config.font = wezterm.font('UDEV Gothic 35NF', { weight = 'Bold' })
config.font = wezterm.font('HackGen35 Console NF', { weight = 'Bold' })
config.font_size = 13

config.freetype_load_target = 'Light'
front_end = "OpenGL"

-- thickness of the cursor while insert mode (vertical bar)
config.cursor_thickness = '2px'
config.cursor_blink_rate = 400
config.cursor_blink_ease_in = "Constant"

config.colors = {
  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#f0e68c',
  -- Overrides the text color when the current cell is occupied by the cursor
  -- cursor_fg = 'black',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  -- cursor_border = '#52ad70',
  -- background color while inputting japanese text (before determined)
  compose_cursor = '#242424',
  -- text color while inputting japanese text (before determined)
  cursor_fg = '#e2e2e3',
}

-- ************************************************************************************
-- Key Bindings
-- ************************************************************************************
config.keys = {
  -- This map "hide Application" in default. so change it. neovim maps ctrl-h to moving vertical split bar.
  { key = 'h', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey { key = 'h', mods = 'CTRL' }, },
  -- This map "display log of wezterm" in default. so change it. neovim maps ctrl-l to moving vertical split bar.
  { key = 'l', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey { key = 'l', mods = 'CTRL' }, },
  -- NOTE: neovim maps ctrl-t to `:newtab` of neovim
  { key = 't', mods = 'CMD', action = wezterm.action.SendKey { key = 't', mods = 'CTRL' }, },
  -- NOTE: neovim maps ctrl-space to reverse page move
  { key = ' ', mods = 'SHIFT', action = wezterm.action.SendKey { key = ' ', mods = 'CTRL' }, },
  -- NOTE: neovim maps ctrl-` to select all
  { key = 'a', mods = 'CMD', action = wezterm.action.SendKey { key = '`', mods = 'CTRL' }, },
  -- assigns to 英・かなキー
  --   refs
  --     https://wezfurlong.org/wezterm/config/keys.html#configuring-key-assignments
  --     https://wezfurlong.org/wezterm/config/lua/keyassignment/index.html#available-key-assignments
  --     https://wezfurlong.org/wezterm/config/lua/keyassignment/Multiple.html
  --     https://wezfurlong.org/wezterm/config/lua/wezterm/background_child_process.html
  -- 英キー
  -- { key = '\\', mods = 'CTRL',
    -- action = wezterm.action.Multiple {
      -- wezterm.action.SendKey { key = '\\', mods = 'CTRL' },
      -- wezterm.action_callback(function(win, pane)
        -- wezterm.background_child_process { '/opt/homebrew/bin/nvim', '--server', 'localhost:22222', '--remote-send', '"<ESC>;doautocmd User ImeDeactivated<CR>"' }
      -- end),
    -- },
  -- },
  -- -- かなキー
  -- { key = '|', mods = 'SHIFT|CTRL',
    -- action = wezterm.action.Multiple {
      -- wezterm.action.SendKey { key = '|', mods = 'SHIFT|CTRL' },
      -- wezterm.action_callback(function(win, pane)
        -- wezterm.background_child_process { '/opt/homebrew/bin/nvim', '--server', 'localhost:22222', '--remote-send', '"<ESC>;doautocmd User ImeActivated<CR>"' }
      -- end),
    -- },
  -- },
  -- { key = '+',
    -- action = wezterm.action.Multiple {
      -- wezterm.action.SendKey { key = '+' },
      -- wezterm.action_callback(function(win, pane)
        -- wezterm.background_child_process { '/opt/homebrew/bin/nvim', '--server', 'localhost:22222', '--remote-send', '"<ESC>;doautocmd User ImeDeactivated<CR>"' }
      -- end),
    -- },
  -- },
  -- -- かなキー
  -- { key = '=',
    -- action = wezterm.action.Multiple {
      -- wezterm.action.SendKey { key = '=' },
      -- wezterm.action_callback(function(win, pane)
        -- wezterm.background_child_process { '/opt/homebrew/bin/nvim', '--server', 'localhost:22222', '--remote-send', '"<ESC>;doautocmd User ImeActivated<CR>"' }
      -- end),
    -- },
  -- },
  -- { key = 'raw:102',
    -- action = wezterm.action.Multiple {
      -- wezterm.action.SendKey { key = 'raw:102' },
      -- wezterm.action.SpawnCommandInNewTab {
        -- args = { 'nvim --server localhost:22222 --remote-send "<ESC>;:doautocmd User ImeDeactivated<CR>"' },
      -- },
    -- },
  -- },
  -- -- かなキー
  -- { key = 'raw:104',
    -- action = wezterm.action.Multiple {
      -- wezterm.action.SendKey { key = 'raw:104' },
      -- wezterm.action.SpawnCommandInNewTab {
        -- args = { 'nvim --server localhost:22222 --remote-send "<ESC>;:doautocmd User ImeActivated<CR>"' },
      -- },
    -- },
  -- },
}

-- ************************************************************************************
-- For Debug (Basically Disabled)
-- ************************************************************************************
-- this is only for keymapping debug
-- refs
--   - https://wezfurlong.org/wezterm/config/lua/config/debug_key_events.html
--   - https://wezfurlong.org/wezterm/config/lua/config/daemon_options.html
--   - https://wezfurlong.org/wezterm/troubleshooting.html#review-logserror-messages
-- config.debug_key_events = true
-- config.daemon_options = {
  -- stdout = '/Users/akira/wezterm.log',
-- }
-- ************************************************************************************

-- Activate config by returning it
return config
