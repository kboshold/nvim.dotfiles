-- if true then return {} end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {},
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    views = {
      popup = {},
      cmdline_popup = {
        position = {
          row = 16,
          col = "50%",
        },
        size = {
          width = 60
        }
      },
      popupmenu  = {
        relative = "editor",
        position = {
          row = 19,
          col = "50%",
        },
        size = {
          width = 60
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      confirm = {
        position = {
          row = 16,
          col = "50%",
        }
      }
    }
  },
  -- stylua: ignore
  keys = {},

}
