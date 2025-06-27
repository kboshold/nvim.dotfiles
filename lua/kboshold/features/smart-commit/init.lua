local M = {}

local function create_spinner()
  local buf = vim.api.nvim_get_current_buf()

  local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local spinner_index = 1

  local msg = " Smart commit in progress..."
  local ns_id = vim.api.nvim_create_namespace("commit_spinner_namespace")
  local line = 0 -- Display the spinner on the first line of the buffer

  -- Timer to update the spinner
  local timer = vim.loop.new_timer()
  if not timer then
    return nil
  end

  -- Function to update the virtual text
  local tasks = {}
  local function update_spinner()
    if not vim.api.nvim_buf_is_valid(buf) then
      timer:stop()
      return
    end

    local spinner_frame = spinner_frames[spinner_index]
    local lines = {}
    local in_progress = #tasks == 0

    local max_lines = 0
    for _, task in pairs(tasks) do
      local status
      local statusHighlight
      if task.status == "pending" then
        status = spinner_frame
        statusHighlight = "SmartCommitStatusWait"
        in_progress = true
      elseif task.status == "success" then
        status = "󰞑"
        statusHighlight = "SmartCommitStatusSuccess"
      elseif task.status == "error" then
        status = ""
        statusHighlight = "SmartCommitStatusError"
      end

      table.insert(lines, {
        { "  ", "StatusCommitStatus" },
        { "" .. status, statusHighlight },
        { " " .. task.label, "SmartCommitStatus" },
      })
    end

    if not in_progress then
      spinner_frame = "✔"
      msg = "  Smart commit complete."
      timer:stop()
      timer:close()
    end

    table.insert(lines, 1, {
      { spinner_frame, "SmartCommitStatusSpinner" },
      { msg, "SmartCommitStatus" },
    })
    table.insert(lines, {
      {
        "",
        "SmartCommitDivider",
      },
    })

    -- Update virtual text with the current spinner frame
    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1) -- Clear previous virtual text
    vim.api.nvim_buf_set_extmark(buf, ns_id, line, 0, {
      virt_lines = lines,
      virt_lines_above = true,
    })

    if #lines > max_lines then
      max_lines = #lines
      vim.cmd("normal! zb")
    end

    -- Update spinner frame
    spinner_index = (spinner_index % #spinner_frames) + 1
  end

  -- Start the spinner
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "" })
  update_spinner()
  timer:start(0, 100, vim.schedule_wrap(update_spinner))

  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  return {
    register = function(_, task)
      table.insert(tasks, task)
      update_spinner()
    end,
  }
end

local function run_linter(linter, spinner)
  local task = {
    label = linter.label,
    status = "pending",
    code = nil,
  }

  vim.fn.jobstart({ "sh", "-c", linter.command }, {
    cwd = linter.cwd or M.root,
    on_stdout = function(_, data, _) end,
    on_stderr = function(_, data, _) end,
    on_exit = function(_, code, _)
      if code == 0 then
        task.status = "success"
      else
        task.status = "error"
      end
      task.code = code
    end,
  })

  if linter.label then
    spinner:register(task)
  end

  return task
end

local function run_linters(spinner)
  local linters = M.commit_config.linters
  for _, linter in ipairs(linters) do
    run_linter(linter, spinner)
  end
end

local function generate_commit_message(spinner)
  local task = {
    label = " Copilot commit message",
    status = "pending",
    code = nil,
  }
  local buf = vim.api.nvim_get_current_buf()
  -- Setup CopilotChat to generate the commit message
  local chat = require("CopilotChat")
  local prompt = require("kboshold.features.smart-commit.prompt").build_prompt()

  local config = vim.tbl_deep_extend("force", prompt, {
    headless = true,
    callback = function(response)
      local commit_message = string.match(response, "```[`]?.-\n(.-)\n```[`]?")
      if commit_message then
        local lines = vim.split(commit_message, "\n")
        vim.api.nvim_buf_set_lines(buf, 0, 1, false, lines)
        task.status = "success"
        task.code = 0
      else
        task.status = "error"
        task.code = -1
      end
    end,
  })

  spinner:register(task)
  chat.ask(config.prompt, config)
end

local function on_gitcommit_bufenter()
  local buf = vim.api.nvim_get_current_buf()

  local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
  if not (first_line == "" or first_line == nil) then
    return
  end

  local spinner = create_spinner()
  if spinner == nil then
    vim.notify("Failed to create spinner for smart commit.", "error", { title = "Spinner Error" })
    return
  end

  if M.commit_config.message then
    generate_commit_message(spinner)
  end

  run_linters(spinner)
end

local function register_events()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "COMMIT_EDITMSG",
    callback = function(args)
      if vim.b[args.buf].has_smart_commit then
        return
      end
      vim.b[args.buf].has_smart_commit = true
      on_gitcommit_bufenter()
    end,
  })
end

local function load_config(config_path)
  local commit_config = {}
  if config_path then
    commit_config = dofile(config_path)

    if type(commit_config) ~= "table" then
      vim.notify("Config '" .. config_path .. "' file is invalid", vim.log.levels.ERROR)
      return false
    end
  elseif M.config.requires_config_file then
    return
  end

  M.commit_config = vim.tbl_extend("force", {
    root = false,
    enabled = true,
    message = true,
    linters = {},
  }, commit_config or {})

  return true
end

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", {
    config_filenames = { ".smart-commit.lua", "local.smart-commit.lua" },
    requires_config_file = false,
  }, opts or {})

  M.config = config

  local start_dir = vim.fn.expand("%:p:h")
  local config_path = vim.fs.find(M.config.config_filenames, { upward = true, path = start_dir })[1]
  if not load_config(config_path) then
    return
  end

  if not M.commit_config.enabled then
    return
  end

  if M.commit_config.root then
    M.root = vim.fs.root(start_dir, M.commit_config.root)
  else
    M.root = vim.fs.dirname(config_path)
  end

  register_events()
end

return M
