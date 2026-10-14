local colors = { "Mauve", "Blue", "Peach", "Sky", "Pink", "Sapphire", "Red", "Green", "Yellow" }

return {
  "lukas-reineke/indent-blankline.nvim",
  opts = function(_, opts)
    local indent = vim.tbl_map(function(c)
      return "Indent" .. c
    end, colors)
    local scope = vim.tbl_map(function(c)
      return "IndentScope" .. c
    end, colors)

    return vim.tbl_deep_extend("force", opts, {
      indent = { char = "▏", tab_char = "▏", highlight = indent },
      scope = { char = "▏", highlight = scope, show_exact_scope = false },
      whitespace = { highlight = indent, remove_blankline_trail = false },
    })
  end,
}
