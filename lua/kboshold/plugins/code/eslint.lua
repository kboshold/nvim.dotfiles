return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
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
