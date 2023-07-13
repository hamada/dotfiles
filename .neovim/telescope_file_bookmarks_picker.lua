-- ref: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md
--
-- lua helps
--   - https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
--   - https://zenn.dev/slin/articles/2020-10-19-neovim-lua1

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local entry_display = require('telescope.pickers.entry_display')

-- our picker function: file_bookmarks
local file_bookmarks = function(opts)
  opts = opts or {}
  bookmarks = vim.json.decode(vim.fn.join(vim.fn.readfile("/Users/akira/.neovim/.telescope_vim_bookmarks.json"), "\n")) 

  pickers.new(opts, {
	previewer = conf.file_previewer(opts),
    prompt_title = "Bookmarks",
    -- finder = finders.new_table {
    --   results = { "red", "green", "blue" }
    -- },
    finder = finders.new_table {
      results = bookmarks,
      entry_maker = function(entry)
        local displayer = entry_display.create {
            separator = "▏",
            items = {
                { width = opts.width_line or 5 },
                { width = opts.width_text or 38 },
                { remaining = true }
            }
        }

        local make_display = function(entry)
            return displayer {
                -- { 1, "TelescopeResultsIdentifier" },
                nil,
                entry.bookmark_name,
                entry.full_path,
            }
        end

        return {
          value = entry,
          full_path = entry[2],
          bookmark_name = entry[1],
          -- display = entry[1],
          display = make_display,
          ordinal = entry[1],
          -- file_previewer require this `path` field.
          -- refs: 
          --   - https://github.com/nvim-telescope/telescope.nvim/blob/276362a8020c6e94c7a76d49aa00d4923b0c02f3/doc/telescope.txt#L642
          --   - https://github.com/nvim-telescope/telescope.nvim/blob/276362a8020c6e94c7a76d49aa00d4923b0c02f3/lua/telescope/previewers/init.lua#L245C42-L245C46
          path = entry[2]
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        -- vim.api.nvim_echo({ {"selected bookmark: " .. selection.display} }, true, {})
        -- vim.api.nvim_echo({ {"selected full_path: " .. selection.full_path} }, true, {})

        -- print(vim.inspect(selection))
        -- vim.api.nvim_put({ selection[1] }, "", false, true)

        if vim.fn.isdirectory(selection.full_path) ~= 0 then
          vim.cmd('Telescope file_browser path=' .. selection.full_path .. ' select_buffer=true hidden=true hide_parent_dir=true')
        else
          vim.cmd('tabnew ' .. selection.full_path)
        end
      end)
      return true
    end,
  }):find()
end

-- to execute the function
file_bookmarks()
