local M = {}

-- Skip detection for certain filetypes or large files
local function should_skip_detection(buf)
  local ft = vim.bo[buf].filetype
  -- local size = vim.api.nvim_buf_line_count(buf)

  return ft:match("^git") or ft:match("^fugitive")
end

-- Sample lines from buffer for analysis
local function get_sample_lines(buf)
  local line_count = vim.api.nvim_buf_line_count(buf)
  local sample_size = math.min(64, line_count)
  return vim.api.nvim_buf_get_lines(buf, 0, sample_size, false)
end

-- Count different indentation styles in the sample
local function analyze_indentation(lines)
  local result = {
    tab_indent_count = 0,
    space_indent_count = 0,
    indent_sizes = { [2] = 0, [4] = 0, [8] = 0 },
  }

  for _, line in ipairs(lines) do
    -- Only process lines that start with whitespace followed by content
    if line:match("^%s+%S") then
      if line:match("^\t") then
        -- Line starts with a tab
        result.tab_indent_count = result.tab_indent_count + 1
      elseif line:match("^ +") then
        -- Line starts with spaces
        result.space_indent_count = result.space_indent_count + 1

        -- Count leading spaces to determine indent size
        local space_count = #(line:match("^ +"))
        if space_count == 2 then
          result.indent_sizes[2] = result.indent_sizes[2] + 1
        elseif space_count == 4 then
          result.indent_sizes[4] = result.indent_sizes[4] + 1
        elseif space_count == 8 then
          result.indent_sizes[8] = result.indent_sizes[8] + 1
        end
      end
    end
  end

  return result
end

-- Apply detected settings to the buffer
local function apply_indent_settings(buf, analysis)
  if analysis.tab_indent_count > analysis.space_indent_count then
    -- Tabs are more common - use tabs
    vim.bo[buf].expandtab = false
  else
    -- Spaces are more common - use spaces
    vim.bo[buf].expandtab = true

    -- Determine most common indent size
    local indent_size = 4
    local max_count = 0
    for size, count in pairs(analysis.indent_sizes) do
      if count > max_count then
        max_count = count
        indent_size = size
      end
    end

    -- Apply detected indent size
    vim.bo[buf].tabstop = indent_size
    vim.bo[buf].shiftwidth = indent_size
    vim.bo[buf].softtabstop = indent_size
  end
end

-- Main function to detect and apply indentation settings
function M.detect_indent(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  if should_skip_detection(buf) then
    return
  end

  local sample_lines = get_sample_lines(buf)
  local analysis = analyze_indentation(sample_lines)
  apply_indent_settings(buf, analysis)
end

-- Set up detection autocommand
function M.setup()
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("DetectIndent", { clear = true }),
    callback = function(args)
      M.detect_indent(args.buf)
    end,
  })

  return M
end

return M
