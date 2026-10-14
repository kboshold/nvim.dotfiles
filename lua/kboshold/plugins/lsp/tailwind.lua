local ROOT_FILES = {
  "tailwind.config.js",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
  "tailwind.config.ts",
  "postcss.config.js",
  "postcss.config.cjs",
  "postcss.config.mjs",
  "postcss.config.ts",
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        -- lspconfig falls back to `.git`, which starts the server in every repo
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local markers = require("lspconfig.util").insert_package_json(vim.deepcopy(ROOT_FILES), "tailwindcss", fname)
          local found = vim.fs.find(markers, { path = fname, upward = true })[1]
          if found then
            on_dir(vim.fs.dirname(found))
          end
        end,
      },
    },
  },
}
