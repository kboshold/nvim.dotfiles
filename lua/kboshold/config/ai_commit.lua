-- Generate a Conventional Commit message for the staged diff via `codex exec`.
local M = {}

local MAX_DIFF_CHARS = 60000

local PROMPT = table.concat({
  "Write a git commit message for the staged diff in <stdin>.",
  "Use Conventional Commits: `<type>(<scope>): <description>`, imperative, lowercase, max 72 chars.",
  "Add a short body only if the why is not obvious from the subject.",
  "Output only the commit message, no code fences, no explanations.",
}, " ")

-- number of lines above git's comment block
local function message_end(buf)
  local count = 0
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line:match("^#") then
      break
    end
    count = i
  end
  return count
end

local function has_message(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, message_end(buf), false)
  return vim.iter(lines):any(function(line)
    return vim.trim(line) ~= ""
  end)
end

local function insert_message(buf, message, force)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if not force and has_message(buf) then
    return
  end
  local lines = vim.split(vim.trim(message), "\n", { plain = true })
  table.insert(lines, "")
  vim.api.nvim_buf_set_lines(buf, 0, message_end(buf), false, lines)
end

---@param buf integer
---@param force boolean replace an existing message
function M.generate(buf, force)
  local diff = vim.system({ "git", "diff", "--cached", "--no-color" }, { text = true }):wait()
  if diff.code ~= 0 or vim.trim(diff.stdout or "") == "" then
    if force then
      vim.notify("No staged changes", vim.log.levels.WARN)
    end
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
      insert_message(buf, table.concat(lines, "\n"), force)
    end)
  end)
end

-- auto-generate for a fresh `git commit` (skips amend, merge, reword, -m)
function M.auto(buf)
  if vim.fs.basename(vim.api.nvim_buf_get_name(buf)) ~= "COMMIT_EDITMSG" or has_message(buf) then
    return
  end
  M.generate(buf, false)
end

return M
