-- Disable vtsls LSP server to avoid conflicts with typescript-tools
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Disable vtsls completely
      vtsls = {
        enabled = false,
      },
      -- Also disable tsserver if it's somehow enabled
      tsserver = {
        enabled = false,
      },
    },
  },
}
