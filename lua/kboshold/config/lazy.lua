require("lazy").setup({
  spec = {
    -- We could do this dynamic using vim.fn.readdir but why should we waste time?
    -- { import = "kboshold.config.plugins.debug" },
    { import = "kboshold.config.plugins.lsp" },
    { import = "kboshold.config.plugins.color" },
    { import = "kboshold.config.plugins.ui" },
    { import = "kboshold.config.plugins.util" }
  },
  defaults = {
    lazy = false,
    version = false
  },
  install = {},
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

return {}
