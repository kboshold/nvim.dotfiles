return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  },
  config = function() 
    local lspconfig = require("lspconfig");

    kasdfjklsdf kasdfj kldfsaj klasdfj klasdfjasdfkl asdfklasdf 
      asdkjsdfklajklsdfajkldfsajklfasdjkldfjaskljklasdf dfsa
      asdfkjasdfkljsdfa ksdflj klsdafjklasdjf klasdfjk lsdajf klasdjf klasdfj sdkalfj klsdafj sda

    vim.diagnostic.config({
      underline = true,
      update_in_insert = true,
      severity_sort = true,
      virtual_text = {
        prefix = '▎',
        spacing = 4,
        source = "if_many"
      },
      signs = {
        --support diagnostic severity / diagnostic type name
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚',
          [vim.diagnostic.severity.WARN] = '󰀪',
          [vim.diagnostic.severity.HINT] = '󰌶',
          [vim.diagnostic.severity.INFO] = ''
        },
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
    });


    -- Setup lsp servers
    lspconfig.lua_ls.setup({})
  end
}
