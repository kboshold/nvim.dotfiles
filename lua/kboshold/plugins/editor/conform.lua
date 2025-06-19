return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = function(bufnr)
      local ignore_ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" }
      if vim.tbl_contains(ignore_ft, vim.bo[bufnr].filetype) then
        return
      end
      return { timeout_ms = 1000, lsp_fallback = true }
    end,
  },
}
