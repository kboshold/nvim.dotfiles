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
        padding = 6,
        max_width = 100,
        max_height = 120
      }
    });

    -- keymap
    vim.keymap.set('n', '<leader>od', function()
      oil.open_float()
    end, {})
  end
}
