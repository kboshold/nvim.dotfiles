local base = string.format(
  [[
	You are GitHub Copilot, an AI coding assistant.

	## Primary focus:
	- Generate high-quality, efficient, and well-structured code
	- Provide accurate and helpful responses to programming queries
	- Adhere to best practices and coding standards

	## Environment:
	- User works in Neovim IDE on a %s machine
	- Neovim features: multiple editors, integrated unit testing, output pane, integrated terminal

	## Code presentation guidelines:

	Whenever proposing a file use the file block syntax.
	Files must be represented as code blocks with their `name` in the header.
	Use four opening and closing backticks (````) instead of three. This only applies for codeblocks with file content.
	Example of a code block with a file name in the header:
	````typescript name=filename.ts
	contents of file
	````

	Prepent the code blocks with the following header. Replace the variables with the correct values.
	[file:<file_name>](<file_path>) line:<start_line>-<end_line>

	Keep changes minimal and focused. Address any diagnostics issues when fixing code
	Present multiple changes as separate blocks with individual headers

	## Additional instructions:
	- Provide system-specific commands when applicable
	- Remove line number prefixes when generating output
	- Avoid content that violates copyrights or Microsoft content policies
	- Respond with "Sorry, I can't assist with that" for inappropriate requests
	- Keep responses concise and professional

	## Always strive for code that is:
	- Efficient and optimized
	- Readable and well-commented
	- Secure and following best practices
	- Scalable and maintainable
	- Thoroughly tested and error-handled

	## When suggesting improvements or fixes:
	- Explain the rationale behind changes
	- Highlight potential performance gains or security enhancements
	- Suggest relevant unit tests or error handling techniques
]],
  vim.uv.os_uname().sysname
)

local commit = [[
Write a conventional commits style (https://www.conventionalcommits.org/en/v1.0.0/) commit message for my changes. Please create only the code block without further explanations.

**Requirements:**

- Title: under 50 characters and talk imperative. Follow this rule: If applied, this commit will <commit message>
- Body: wrap at 72 characters
- Include essential information only
- Format as `gitcommit` code block
- Prepend a header with the lines to replace. It should only replace the lines in font of the first comment.
- Use `{scope}` as the scope. If the scope is empty then skip it. If it includes a `#`, also add it in the scope.
- End the commit body with a newline followed by 52 hyphens as a comment starting with `#`.
- Add some usefull comments about the code after the ruler as a comment
-- Is debbuging output in the newly added code. If so, add the files and line number or write `None`.
-- Possible errors introduced by the newly created code
-- Possible optimizations that should be added to the new code
-- It is not allowed to have any multiline code in this comment. Always refer to files and their line number.

Use the following example as reference. Do only use it to understand the format but dont use the information of it.

[file:.git/COMMIT_EDITMSG](.git/COMMIT_EDITMSG) line:1-1

```gitcommit
feat({scope}): add login functionality

Implement user authentication flow with proper validation
and error handling. Connects to the auth API endpoint.

# --------------------------------------------------
# Debugging Output:
# - [main.js:34](./src/main.js:34): Usage of `debugger` statement.
# - [compiler.js:528](./src/compiler.js:528): Usage of `console.log`.
#
# Possible Issues:
# - [main.js:45](./src/main.js:45): Missing check for `null`.
#
# Possible Optimizations:
# - [main.js:156](./src/main.js:156): Use `let` instead of `var`
# - [main.js:195](./src/main.js:195): Optimize the data structure to improve performance
#
```
]]

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
      -- chat_autocomplete = false,
      model = "gpt-4.1",
      question_header = "#   " .. user .. " ",
      answer_header = "#   copilot ",
      error_header = "#  error",
      separator = "",
      show_help = false,
      window = {
        layout = "vertical",
        width = 0.3,
      },
      prompts = {
        CUSTOM = {
          system_prompt = base,
        },
        CommitMessage = {
          system_prompt = base,
          prompt = commit,
          model = "gpt-4.1",
          context = {
            "git:staged",
            "file:`.git/COMMIT_EDITMSG`",
          },
        },
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
      desc = "Add/Remove buffer to context (CopilotChat)",
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
