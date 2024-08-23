return {
  "folke/zen-mode.nvim",
  config = function()
    
      -- Key.Desc: Enables the zen-mode with a width of 120 and with numbers.
      vim.keymap.set("n", "<leader>zz", function()
          require("zen-mode").setup {
              window = {
                  width = 120,
                  options = { }
              },
          }
          require("zen-mode").toggle()
          vim.wo.wrap = false
          vim.wo.number = true
          vim.wo.rnu = true
          ColorMyPencils()
      end)

      -- Key.Desc: Enables the zen-mode with a width of 100 and without numbers.
      vim.keymap.set("n", "<leader>zZ", function()
          require("zen-mode").setup {
              window = {
                  width = 100,
                  options = { }
              },
          }
          require("zen-mode").toggle()
          vim.wo.wrap = false
          vim.wo.number = false
          vim.wo.rnu = false
          vim.opt.colorcolumn = "0"
          ColorMyPencils()
      end, { desc = "" })
  end
}
