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

    -- TODO: Keymap
    -- Keymap.Desc: Enables the zen-mode with a width of 100 and without numbers.
    vim.keymap.set("n", "<leader>zZ", function()
      local zenmode = require("zen-mode");
      zenmode.setup {
        window = {
            width = 100,
            options = { }
        },
      }
      zenmode.toggle()
      vim.wo.wrap = false
      vim.wo.number = false
      vim.wo.rnu = false
      vim.opt.colorcolumn = "0"
    end)
  end
}
