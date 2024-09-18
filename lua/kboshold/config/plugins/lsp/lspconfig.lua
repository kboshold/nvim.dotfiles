return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  },
  config = function() 
    local lspconfig = require("lspconfig");



    vim.diagnostic.config({
      virtual_text = {
        prefix = '▎',
      },
      signs = {
        --support diagnostic severity / diagnostic type name
        text = {
          [1] = '󰅚',
          ['ERROR'] = '󰅚',
          ['WARN'] = '󰀪',
          ['HINT'] = '󰌶',
          ['INFO'] = ''
        },
      },

    });


    -- Setup lsp servers
    lspconfig.lua_ls.setup({})
  end
}
