-- DISABLED: Use typescript-toggle.lua or typescript-flexible.lua instead
-- This is the original typescript-tools configuration, kept for reference

if false then
  return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      -- Original configuration here...
    },
  }
end

return {}
