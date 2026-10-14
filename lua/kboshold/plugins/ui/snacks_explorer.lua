return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = true,
      show_hidden = true,
      show_git_ignored = false,
    },
    picker = {
      sources = {
        explorer = {
          follow_file = true,
          tree = true,
          jump = { close = false },
          auto_close = false,
          hidden = true,
          win = {
            list = {
              keys = {
                ["<ESC>"] = function()
                  vim.cmd("TmuxNavigateRight")
                end,
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        if explorer then
          explorer:focus()
        else
          Snacks.explorer()
        end
      end,
      desc = "File Explorer",
    },
  },
  init = function()
    -- only auto-open on wide terminals
    if vim.o.columns <= 158 then
      return
    end
    -- open for no arguments (current directory) or when a directory is opened
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("kboshold_explorer", { clear = true }),
      once = true,
      callback = function(data)
        if vim.g.ux_piped_input == 1 then
          return
        end
        local is_directory = vim.fn.isdirectory(data.file) == 1
        local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
        if is_directory or no_name then
          Snacks.explorer({ focus = false })
        end
      end,
    })
  end,
}
