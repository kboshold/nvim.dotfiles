-- TypeScript/JavaScript support with typescript-tools
-- Set this flag to choose your TypeScript LSP server
local USE_TYPESCRIPT_TOOLS = true -- Set to false to use vtsls instead

if USE_TYPESCRIPT_TOOLS then
  return {
    -- Disable vtsls completely
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          vtsls = { enabled = false },
          tsserver = { enabled = false },
        },
      },
    },

    -- Enable typescript-tools for TS/JS files only (NOT Vue)
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- Removed "vue"
      opts = {
        filetypes = {
          "javascript",
          "javascriptreact", 
          "typescript",
          "typescriptreact",
          -- Removed "vue" - let Volar handle Vue files
        },
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = "all",
          tsserver_max_memory = 4096,
          complete_function_calls = true,
          include_completions_with_insert_text = true,
          code_lens = "off",
          disable_member_code_lens = true,
          single_file_support = false,
          
          -- Remove Vue TypeScript plugin since we're not handling Vue files
          -- tsserver_plugins = {
          --   "@vue/typescript-plugin",
          -- },
          
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "literals",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
          },
          
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      },
      config = function(_, opts)
        require("typescript-tools").setup(opts)
        
        -- Keymaps for TypeScript/JavaScript/Vue files
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- Removed "vue"
          callback = function()
            map("n", "<leader>cto", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
            map("n", "<leader>ctu", "<cmd>TSToolsRemoveUnused<cr>", "Remove Unused")
            map("n", "<leader>ctd", "<cmd>TSToolsRemoveUnusedImports<cr>", "Remove Unused Imports")
            map("n", "<leader>cta", "<cmd>TSToolsAddMissingImports<cr>", "Add Missing Imports")
            map("n", "<leader>ctf", "<cmd>TSToolsFixAll<cr>", "Fix All")
            map("n", "<leader>ctr", "<cmd>TSToolsRenameFile<cr>", "Rename File")
            map("n", "<leader>ctg", "<cmd>TSToolsGoToSourceDefinition<cr>", "Go to Source Definition")
            map("n", "<leader>ctF", "<cmd>TSToolsFileReferences<cr>", "File References")
            map("n", "<leader>ctR", "<cmd>TSToolsRestart<cr>", "Restart TypeScript Server")
          end,
        })
      end,
    },

    -- TreeSitter support for TypeScript/JavaScript
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "typescript", "javascript", "tsx", "jsx" })
      end,
    },
  }
else
  -- vtsls configuration
  return {
    -- Import TypeScript extra
    { import = "lazyvim.plugins.extras.lang.typescript" },
    
    -- Disable typescript-tools
    {
      "pmizio/typescript-tools.nvim",
      enabled = false,
    },

    -- TreeSitter support
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "typescript", "javascript", "tsx", "jsx" })
      end,
    },
  }
end
