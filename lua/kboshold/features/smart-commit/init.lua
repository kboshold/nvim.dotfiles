local M = {}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", {
    config_filenames = { ".smart-commit.conf", "local.smart-commit.conf" },
  }, opts or {})

  M.config = config

  M.find_config()
end

function M.find_config()
  local start_dir = vim.fn.expand("%:p:h")
  local config_path = vim.fs.find(M.config.config_filenames, { upward = true, path = start_dir })[1]

  M.config.config_file = config_path
end

return M
