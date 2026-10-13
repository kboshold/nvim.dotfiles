-- Generate a Conventional Commit message for the staged diff via `codex exec`.
local M = {}

local MAX_DIFF_CHARS = 60000

local PROMPT = table.concat({
  "Write a git commit message for the staged diff in <stdin>.",
  "Use Conventional Commits: `<type>(<scope>): <description>`, imperative, lowercase, max 72 chars.",
  "Add a short body only if the why is not obvious from the subject.",
  "Output only the commit message, no code fences, no explanations.",
}, " ")

local function insert_message(buf, message)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local lines = vim.split(vim.trim(message), "\n", { plain = true })
  -- replace the empty lines above git's comment block
  local first_comment = 0
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line:match("^#") then
      break
    end
    if vim.trim(line) ~= "" then
      vim.notify("Commit message not empty, skipping", vim.log.levels.WARN)
      return
    end
    first_comment = i
  end
  table.insert(lines, "")
  vim.api.nvim_buf_set_lines(buf, 0, first_comment, false, lines)
end

function M.generate(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local diff = vim.system({ "git", "diff", "--cached", "--no-color" }, { text = true }):wait()
  if diff.code ~= 0 or vim.trim(diff.stdout or "") == "" then
    vim.notify("No staged changes", vim.log.levels.WARN)
    return
  end

  local out_file = vim.fn.tempname()
  local model = vim.g.ai_commit_model or "gpt-6-luna"
  vim.notify("Generating commit message (" .. model .. ")...")

  vim.system({
    "codex",
    "exec",
    "-m",
    model,
    "-c",
    'model_reasoning_effort="low"',
    "--sandbox",
    "read-only",
    "--ephemeral",
    "--skip-git-repo-check",
    "--color",
    "never",
    "-o",
    out_file,
    PROMPT,
  }, { stdin = diff.stdout:sub(1, MAX_DIFF_CHARS), text = true }, function(result)
    vim.schedule(function()
      local ok, lines = pcall(vim.fn.readfile, out_file)
      vim.fn.delete(out_file)
      if result.code ~= 0 or not ok or #lines == 0 then
        vim.notify("codex failed: " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
        return
      end
      insert_message(buf, table.concat(lines, "\n"))
    end)
  end)
end

return M
