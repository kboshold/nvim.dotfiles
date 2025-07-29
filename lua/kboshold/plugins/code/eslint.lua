return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          -- ESLint LSP is disabled
          enabled = false,
          settings = {
            options = {
              overrideConfigFile = "eslint.config.mjs",
            },
          },
        },
      },
    },
  },
}
