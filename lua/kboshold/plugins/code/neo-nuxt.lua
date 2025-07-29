if true then
  return {}
end
return {
  {
    "kboshold/neo-nuxt.nvim",
    dir = "/home/kboshold/workspace/config/neo-nuxt.nvim",
    name = "neo-nuxt",
    enabled = false,
    lazy = false,
    config = function()
      require("neo-nuxt").setup({
        debug = true,
        enable_hello_completion = true,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "kboshold/neo-nuxt.nvim" },
    opts = function(_, opts)
      -- Ensure sources table exists
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Add neo-nuxt to default sources
      table.insert(opts.sources.default, "neo-nuxt")

      -- Add neo-nuxt provider configuration
      opts.sources.providers["neo-nuxt"] = {
        name = "neo-nuxt",
        module = "blink-cmp-neo-nuxt",
        kind = "NeoNuxt",
        score_offset = 50,
        async = true,
        enabled = function()
          local ft = vim.bo.filetype
          return ft == "lua" or ft == "vue" or ft == "typescript"
        end,
      }

      return opts
    end,
  },
}
