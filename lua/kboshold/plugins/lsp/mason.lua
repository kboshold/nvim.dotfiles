return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    -- table.insert(opts.ensure_installed, "vue_ls@v2.2.12")
  end,
}
