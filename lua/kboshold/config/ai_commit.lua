-- Generate a Conventional Commit message for the staged diff via `codex exec`.
local M = {}

local MAX_DIFF_CHARS = 60000
local DIFF_CMD = {
  "git",
  "diff",
  "--cached",
  "--no-color",
  "--",
  ":/",
  ":(exclude,glob,top)**/*.lock",
  ":(exclude,glob,top)**/*-lock.*",
}

local PROMPT = table.concat({
  "Write a git commit message for the staged diff in <stdin>.",
  "Use Conventional Commits: `<type>(<scope>): <description>`, imperative, lowercase, max 72 chars.",
  "Add a short body only if the why is not obvious from the subject.",
  "Output only the commit message, no code fences, no explanations.",
}, " ")

-- git starts the editor in the repo; elsewhere use the buffer's repo
local function repo_cwd(buf)
  local is_commit_msg = vim.fs.basename(vim.api.nvim_buf_get_name(buf)) == "COMMIT_EDITMSG"
  return not is_commit_msg and vim.fs.root(buf, ".git") or nil
end

local function comment_prefix(buf)
  if not vim.b[buf].ai_commit_comment then
    local cwd = repo_cwd(buf)
    local prefix = "#"
    for _, key in ipairs({ "core.commentString", "core.commentChar" }) do
      local value =
        vim.trim(vim.system({ "git", "config", "--get", key }, { text = true, cwd = cwd }):wait().stdout or "")
      if value ~= "" then
        prefix = value ~= "auto" and value or prefix
        break
      end
    end
    vim.b[buf].ai_commit_comment = prefix
  end
  return vim.b[buf].ai_commit_comment
end

-- number of lines above git's comment block
local function message_end(buf)
  local prefix = comment_prefix(buf)
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if vim.startswith(line, prefix) then
      return i - 1
    end
  end
  return vim.api.nvim_buf_line_count(buf)
end

-- any non-comment text before git's scissors line
local function has_message(buf)
  local prefix = comment_prefix(buf)
  local scissors = prefix .. " ------------------------ >8 ------------------------"
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line == scissors then
      return false
    end
    if not vim.startswith(line, prefix) and vim.trim(line) ~= "" then
      return true
    end
  end
  return false
end

---@param buf integer
---@param force boolean replace an existing message
function M.generate(buf, force)
  if not force and has_message(buf) then
    return
  end
  if vim.fn.executable("codex") == 0 then
    if force then
      vim.notify("codex not found", vim.log.levels.WARN)
    end
    return
  end
  local diff = vim.system(DIFF_CMD, { text = true, cwd = repo_cwd(buf) }):wait()
  if diff.code ~= 0 or vim.trim(diff.stdout or "") == "" then
    if force then
      vim.notify("No staged changes (lockfiles ignored)", vim.log.levels.WARN)
    end
    return
  end

  -- apply only if this is the latest request and the buffer is untouched
  local request = (vim.b[buf].ai_commit_request or 0) + 1
  vim.b[buf].ai_commit_request = request
  local original = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

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
      if
        not vim.api.nvim_buf_is_valid(buf)
        or vim.b[buf].ai_commit_request ~= request
        or not vim.deep_equal(vim.api.nvim_buf_get_lines(buf, 0, -1, false), original)
      then
        return
      end
      local message = vim.split(vim.trim(table.concat(lines, "\n")), "\n", { plain = true })
      table.insert(message, "")
      vim.api.nvim_buf_set_lines(buf, 0, message_end(buf), false, message)
    end)
  end)
end

-- auto-generate for a fresh `git commit` (skips amend, merge, reword, -m)
function M.auto(buf)
  if vim.fs.basename(vim.api.nvim_buf_get_name(buf)) ~= "COMMIT_EDITMSG" then
    return
  end
  M.generate(buf, false)
end

return M
