return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
      "nvim-lua/plenary.nvim"
  },

  config = function()
      require('telescope').setup({})

      -- TODO: Keymap
      local builtin = require('telescope.builtin')
      
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
  end
}
