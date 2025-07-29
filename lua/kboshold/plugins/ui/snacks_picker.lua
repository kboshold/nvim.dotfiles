return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          -- Only use package.json and .git as root markers, exclude tsconfig.json
          root_markers = { "package.json", ".git" },
        },
      },
    },
  },
}
