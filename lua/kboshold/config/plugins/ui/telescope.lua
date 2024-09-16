return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
      "nvim-lua/plenary.nvim"
  },

  config = function()
    require('telescope').setup({})

    -- TODO: Keymap
    local builtin = require('telescope.builtin')
    local utils = require("telescope.utils")

    -- find
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fd', function()
      builtin.find_files({ 
        cwd = utils.buffer_dir()
      })
    end, {})
    vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', function() 
      builtin.buffers({
        sort_mru = true,
        sort_lastused = true
      })
    end, {})
    vim.keymap.set('n', '<leader>fr', function()
      builtin.oldfiles({
        cwd = vim.uv.cwd()
      }) 
    end, {})
    vim.keymap.set('n', '<leader>fR', function()
      builtin.oldfiles({
        sort_mru = true,
        sort_lastused = true
      }) 
    end, {})

    -- search
    vim.keymap.set('n', '<leader>s"', builtin.registers, {})

  end,
}
