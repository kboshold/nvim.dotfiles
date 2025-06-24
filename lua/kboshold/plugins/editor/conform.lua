return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      vue = { "eslint_d", "eslint", lsp_format = "fallack" },
      javascript = { "eslint_d", "eslint", lsp_format = "fallack" },
      javascriptreact = { "eslint_d", "eslint", lsp_format = "fallack" },
      typescript = { "eslint_d", "eslint", lsp_format = "fallack" },
      typescriptreact = { "eslint_d", "eslint", lsp_format = "fallack" },
    },
    formatters = {
      eslint = {
        -- command = function()
        --   local root = require("conform.util").root_file({ "package.json" })
        --   if root then
        --     return root .. "/node_modules/.bin/eslint"
        --   end
        --   return "eslint" -- Fallback to global eslint if not found
        -- end,
        command = "./node_modules/.bin/eslint",
        args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
        cwd = require("conform.util").root_file({ "package.json" }),
      },
    },
  },
}
