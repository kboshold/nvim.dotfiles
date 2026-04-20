return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Oil",
  opts = {
    default_file_explorer = false,
    delete_to_trash = true,
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      max_width = 140,
      max_height = 50,
      preview_split = "right",
    },
  },
  keys = {
    {
      "<leader>oo",
      function()
        require("oil").open()
      end,
      desc = "Oil",
    },
    {
      "<leader>od",
      function()
        local oil = require("oil")
        oil.toggle_float()
        -- using OilEnter does not work quite well
        vim.defer_fn(function()
          oil.open_preview()
        end, 50)
      end,
      desc = "Oil Preview",
    },
  },
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(opts)

    -- autocmd to have additional keymaps for preview
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        if vim.api.nvim_win_get_config(0).relative ~= "" then -- Check if the window is floating
          local bufopts = { noremap = true, silent = true, buffer = true }

          vim.keymap.set("n", "q", oil.toggle_float, bufopts)
          vim.keymap.set("n", "<ESC>", oil.toggle_float, bufopts)

          vim.keymap.set("n", "<CR>", function()
            oil.select({}, function(_) end)
          end, bufopts)
        end
      end,
    })
  end,
}
