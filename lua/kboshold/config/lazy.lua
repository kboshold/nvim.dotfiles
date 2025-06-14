local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
if vim.fn.filewritable(lockfile) ~= 1 then
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json"
end

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },

    -- import/override with your plugins
    { import = "kboshold.plugins.ai" },
    { import = "kboshold.plugins.color" },
    { import = "kboshold.plugins.code" },
    { import = "kboshold.plugins.editor" },
    { import = "kboshold.plugins.ui" },
    { import = "kboshold.plugins.util" },
    { import = "kboshold.plugins.lsp" },
    { import = "kboshold.plugins.navigation" },
    { import = "kboshold.plugins.lazy" },
  },
  lockfile = lockfile,
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {},
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
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
