return {
  "folke/zen-mode.nvim",

  config = function()
    -- TODO: Keymap
    -- Keymap.Desc: Enables the zen-mode with a width of 120 and with numbers.
    vim.keymap.set("n", "<leader>zz", function()
      local zenmode = require("zen-mode");
      zenmode.setup {
        window = {
            width = 120,
            options = { }
        },
      }
      zenmode.toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
    end)
  end
}
