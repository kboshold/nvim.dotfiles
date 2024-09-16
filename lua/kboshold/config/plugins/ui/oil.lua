return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },

  config = function()
    local oil = require('oil')

    oil.setup({
      default_file_explorer = false,
      delete_to_trash = true,
      view_options = {
        show_hidden = true
      },
      float = {
        padding = 2,
        max_width = 140,
        max_height = 50,
        preview_split = "right",
      },
    });

    -- keymap
    local open_preview = false
    vim.keymap.set('n', '<leader>od', function()
      open_preview = true
      oil.toggle_float()

      -- using OilEnter does not work quite well
      vim.defer_fn(function()
        oil.open_preview()
      end, 50)
    end, {})

    -- autocmd to have additional keymaps for preview
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        if vim.api.nvim_win_get_config(0).relative ~= "" then -- Check if the window is floating
          vim.keymap.set('n', 'q', oil.toggle_float, { noremap = true, silent = true, buffer = true })
          vim.keymap.set('n', '<ESC>', oil.toggle_float, { noremap = true, silent = true, buffer = true })
        end
      end,
    })
  end
}
