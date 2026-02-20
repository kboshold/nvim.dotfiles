local function from_node_modules(command)
  return function(self, ctx)
    local root = vim.fs.root(ctx.dirname, { "package.json" })
    if root then
      local local_path = vim.fs.joinpath(root, "node_modules/.bin", command)
      local f = io.open(local_path, "r")
      if f then
        f:close()
        return local_path -- Return the local path if it exists
      end
    end
    return command -- Fallback to global command if not found
  end
end

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      vue = { "eslint_d", lsp_format = "fallback" },
      javascript = { "eslint_d", lsp_format = "fallback" },
      javascriptreact = { "eslint_d", lsp_format = "fallback" },
      typescript = { "eslint_d", lsp_format = "fallback" },
      typescriptreact = { "eslint_d", lsp_format = "fallback" },
      prisma = { "prisma", lsp_format = "fallback" },
      json = { "jsonsort", lsp_format = "first" },
      nix = { "alejandra", lsp_format = "fallback" },
      lua = { "stylua", lsp_format = "fallback" },
    },
    formatters = {
      eslint_d = {
        command = from_node_modules("eslint_d"),
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
        cwd = require("conform.util").root_file({ "package.json" }),
      },
      prisma = {
        command = from_node_modules("prisma"),
        args = { "format", "--schema", "$FILENAME" },
        stdin = false,
        cwd = require("conform.util").root_file({ "package.json" }),
      },
      jsonsort = {
        command = from_node_modules("jsonsort"),
        args = { "$FILENAME" },
        stdin = false,
        cwd = require("conform.util").root_file({ "package.json" }),
        condition = function(_, ctx)
          return ctx.filename:match("[/\\]locales[/\\]")
        end,
      },
    },
  },
}
