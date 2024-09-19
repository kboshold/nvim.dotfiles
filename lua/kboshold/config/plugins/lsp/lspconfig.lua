return { "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  },
  config = function()
    local lspconfig = require("lspconfig");

    vim.diagnostic.config({
      underline = true,
      update_in_insert = true,
      severity_sort = true,
      virtual_text = {
        prefix = '▎',
        spacing = 0,
        virt_text_win_col = 120,
        virt_text_pos = "right_align",
        -- format = function(diagnostic)
        --   return diagnostic.message:gsub("[\n\t]+", " "):gsub("^%s+", ""):gsub("%s+", " ")
        -- end,
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
    lspconfig.lua_ls.setup({
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths here.
              "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {}
      }
    })
  end
}
