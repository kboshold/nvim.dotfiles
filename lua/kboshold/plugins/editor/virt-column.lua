return {
  "lukas-reineke/virt-column.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    highlight = {
      "ColorColumnBlue",
      "ColorColumnRed",
    },
  },
}
