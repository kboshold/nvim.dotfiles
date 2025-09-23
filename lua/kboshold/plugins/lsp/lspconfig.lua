return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        vtsls = function()
          if vim.env.NVIM_DISABLE_TS_LSP then
            -- Returning true prevents LazyVim from setting up the server
            return true
          end
        end,
      },
    },
  },
}
