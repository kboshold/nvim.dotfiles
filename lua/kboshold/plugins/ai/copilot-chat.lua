return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "copilot-chat" },
      },
      ft = { "markdown", "copilot-chat" },
    },
  },
  opts = function()
    local user = vim.env.USER or "User"
    return {
      auto_insert_mode = true,
      model = "claude-3.7-sonnet",
      question_header = "#   " .. user .. " ",
      answer_header = "#   copilot ",
      error_header = "#  error",
      separator = "",
      show_help = false,
      window = {
        layout = "vertical",
        width = 0.3,
      },
    }
  end,
  config = function(_, opts)
    local chat = require("CopilotChat")

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true
        vim.opt_local.signcolumn = "no"
        vim.opt_local.wrap = true
        vim.opt_local.numberwidth = 3
      end,
    })

    chat.setup(opts)
  end,

  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    -- CopilotChat keymaps
    {
      "<leader>at",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>aa",
      function()
        local found = false
        for _, win in pairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "copilot-chat" then
            vim.api.nvim_set_current_win(win)
            vim.cmd("normal! G$a")
            found = true
            break
          end
        end

        if not found then
          require("CopilotChat").toggle()
        end
      end,
      desc = "Ask/Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
      function()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_path = vim.api.nvim_buf_get_name(current_buf)

        -- Get relative path from project root
        local relative_path = current_path
        local cwd = vim.fn.getcwd()
        if vim.startswith(current_path, cwd) then
          relative_path = current_path:sub(#cwd + 2) -- +2 to remove the leading slash
        end

        -- Search for the copilot-chat buffer
        local chat_buf = nil
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "copilot-chat" then
            chat_buf = buf
            break
          end
        end

        if not chat_buf then
          vim.notify("CopilotChat buffer not found", vim.log.levels.ERROR)
          return
        end

        -- Get buffer content
        local lines = vim.api.nvim_buf_get_lines(chat_buf, 0, -1, false)

        -- Find the last line containing "## kboshold"
        local last_user_line = -1
        for i = #lines, 1, -1 do
          if string.match(lines[i], "^# ") then
            last_user_line = i
            break
          end
        end
        last_user_line = last_user_line + 1

        if last_user_line == -1 then
          vim.notify("No conversation found in CopilotChat", vim.log.levels.ERROR)
          return
        end

        -- Check if the context line exists after the user's message
        local context_line = "> #buffer:" .. relative_path
        local has_context = false

        for i = last_user_line + 1, #lines do
          if lines[i] == context_line then
            has_context = true
            break
          end
        end

        if has_context then
          -- Remove the context line
          table.remove(lines, last_user_line + 1)
          vim.api.nvim_buf_set_lines(chat_buf, 0, -1, false, lines)
        else
          -- Add context line after the user's message
          table.insert(lines, last_user_line + 1, context_line)
          vim.api.nvim_buf_set_lines(chat_buf, 0, -1, false, lines)
        end
        vim.cmd("RenderMarkdown")
      end,
      desc = "Add buffer to context (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
  },
}
