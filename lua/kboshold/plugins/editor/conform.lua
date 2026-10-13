local function from_node_modules(command)
  return function(_, ctx)
    local root = vim.fs.root(ctx.dirname, { "package.json" })
    if root then
      local local_path = vim.fs.joinpath(root, "node_modules/.bin", command)
      if vim.uv.fs_stat(local_path) then
        return local_path
      end
    end
    return command
  end
end

return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local package_root = require("conform.util").root_file({ "package.json" })
    local eslint = { "eslint_d", lsp_format = "fallback" }

    -- assign (not extend) so these replace the prettier extra's defaults
    opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
      vue = eslint,
      javascript = eslint,
      javascriptreact = eslint,
      typescript = eslint,
      typescriptreact = eslint,
      prisma = { "prisma", lsp_format = "fallback" },
      json = { "jsonsort", lsp_format = "first" },
      nix = { "alejandra", lsp_format = "fallback" },
      lua = { "stylua", lsp_format = "fallback" },
    })

    opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
      eslint_d = {
        command = from_node_modules("eslint_d"),
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
        cwd = package_root,
      },
      prisma = {
        command = from_node_modules("prisma"),
        args = { "format", "--schema", "$FILENAME" },
        stdin = false,
        cwd = package_root,
      },
      jsonsort = {
        command = from_node_modules("jsonsort"),
        args = { "$FILENAME" },
        stdin = false,
        cwd = package_root,
        condition = function(_, ctx)
          return ctx.filename:match("[/\\]locales[/\\]") ~= nil
        end,
      },
    })
  end,
}
