vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()

    -- automatically open for no arguments (current directory) and when a directory will be opend
    local function open_nvim_tree(data)
      local is_directory = vim.fn.isdirectory(data.file) == 1
      local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

      if not (is_directory or no_name) then
        return
      end

      require("neo-tree.command").execute({ toggle = true })
    end
    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

  end,
  opts = {
    close_if_last_window = true,
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    default_component_configs = {
      indent = {
        with_expanders = true
      },
      modified = {
        symbol = "M"
      },
      git_status = {
        symbols = {
          added     = "", -- Will be green
          modified  = "", -- Will be orange
          deleted   = "D",
          renamed   = "R",
          untracked = "U",
          ignored   = "", -- Will be gray
          unstaged  = "M",
          staged    = "M",
          conflict  = "C",
        },
      },
      file_size = {
        enabled = false
      },
      type = {
        enabled = false
      },
      last_modified = {
        enabled = false
      },
      created = {
        enabled = false
      }
    },
    window = {
      width = 36
    },
    filesystem = {
      use_libuv_file_watcher = true,
      filtered_items = {
        visible  = true,
        hide_dotfiles = false,
        never_show = { "node_modules", ".git" },
      }
    },
  },
  
}
