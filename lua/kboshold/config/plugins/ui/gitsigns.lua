return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- select next
      map('n', '<leader>gn', function()
        if vim.wo.diff then
          vim.cmd.normal({'<leader>gn', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end)

      -- select previous
      map('n', '<leader>gp', function()
        if vim.wo.diff then
          vim.cmd.normal({'<leader>gp', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end)

      -- diff current file
      map('n', '<leader>gd', gitsigns.diffthis)
    end
  },
}
