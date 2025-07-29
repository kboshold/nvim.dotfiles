return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = "vue",
      root = { "vue.config.js" },
    })
  end,

  -- Remove dependency on typescript extra since we're using typescript-tools
  -- { import = "lazyvim.plugins.extras.lang.typescript" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },

  -- Add LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {
          -- Use Volar in Take Over Mode for better Vue + TypeScript integration
          -- This works with typescript-tools running separately
          init_options = {
            vue = {
              hybridMode = false, -- Set to false for Take Over Mode
            },
            typescript = {
              tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
            },
          },
          -- Remove the vtsls-specific handler since we're using typescript-tools
          filetypes = { "vue" },
        },
      },
    },
  },

  -- Ensure typescript-tools is loaded for Vue files that contain TypeScript
  {
    "pmizio/typescript-tools.nvim",
    ft = { "vue" }, -- Add vue to filetypes so it loads for Vue files too
  },
}
