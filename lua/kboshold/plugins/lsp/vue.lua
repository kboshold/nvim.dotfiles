-- Vue.js support with Volar 3 (Take Over Mode)
return {
  -- TreeSitter support for Vue
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vue", "css", "html" })
    end,
  },

  -- Volar LSP for Vue files (Take Over Mode - handles both Vue and TypeScript)
  {
    "neovim/nvim-lspconfig",
    ft = { "vue" },
    opts = {
      servers = {
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = false, -- Take Over Mode - Volar handles TypeScript in Vue files
            },
            typescript = {
              tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
            },
          },
          on_new_config = function(new_config, new_root_dir)
            -- Dynamically set TypeScript SDK path for each project
            local tsdk_path = new_root_dir .. "/node_modules/typescript/lib"
            if vim.fn.isdirectory(tsdk_path) == 1 then
              new_config.init_options.typescript.tsdk = tsdk_path
            end
          end,
          -- Volar 3 handles all Vue file features including TypeScript
          settings = {
            vue = {
              inlayHints = {
                missingProps = true,
                inlineHandlerLeading = true,
                optionsWrapper = true,
              },
            },
          },
        },
      },
    },
  },
}
