return {}
-- -- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- -- TODO: Refactor later
-- vim.api.nvim_create_autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
--       vim.cmd "quit"
--     end
--   end
-- })

-- local function open_nvim_tree(data)

--   local is_directory = vim.fn.isdirectory(data.file) == 0
--   local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

--   -- print(tostring(is_directory) .. " " .. tostring(no_name))
--   if not (is_directory or no_name) then
--     return
--   end

--   require("nvim-tree.api").tree.open({ focus = false, find_file = true, })
-- end

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- return {
--   "nvim-tree/nvim-tree.lua",
--   version = "*",
--   lazy = false,
--   dependencies = {
--     "nvim-tree/nvim-web-devicons",
--   },
--   config = function()
--     require("nvim-tree").setup({
--       -- TODO: Keymap
--       hijack_cursor = true,
--       sync_root_with_cwd = true,
--       view = {
--         adaptive_size = false,
--         width = 36
--       },
--       renderer = {
--         full_name = false,
--         root_folder_label = function(path) 
--           return path:match("([^\\/]*)$")
--         end,
--         icons = {
     
--           git_placement = "right_align",
--           glyphs = {
--             git = {
--               unstaged = "M",
--               staged = "✓",
--               unmerged = "",
--               renamed = "➜",
--               untracked = "★",
--               deleted = "",
--               ignored = "◌",
--             }
--           }
--         },

--       },
--       git = {
--         show_on_dirs = true,
--       }
--     })
--   end,
-- }
