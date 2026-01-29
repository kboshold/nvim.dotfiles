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
    -- automatically open for no arguments (current directory) and when a directory will be opend
    local first_buf_enter = 1
    local function on_buf_enter(data)
      if first_buf_enter == 0 then
        return
      end
      first_buf_enter = 0

      local is_directory = vim.fn.isdirectory(data.file) == 1
      local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
      local is_stream = vim.g.ux_piped_input == 1

      if is_stream then
        return
      end

      if not (is_directory or no_name) then
        return
      end

      Snacks.explorer({ focus = false })
    end

    -- only  open neotree if size is > 158
    if vim.o.columns > 158 then
      vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = on_buf_enter })
    end
  end,
}
