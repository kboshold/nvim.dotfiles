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
    indent_sizes = {}, -- Using a dynamic table instead of fixed sizes
    most_common_size = 0,
  }

  local prev_indent_level = 0
  local indent_differences = {}

  for _, line in ipairs(lines) do
    -- Skip empty lines
    if line:match("^%s*$") then
      goto continue
    end

    -- Get leading whitespace
    local leading_whitespace = line:match("^(%s*)")
    if not leading_whitespace then
      goto continue
    end

    if leading_whitespace:find("\t") then
      -- Line uses tabs for indentation
      result.tab_indent_count = result.tab_indent_count + 1
    else
      -- Line uses spaces for indentation
      local space_count = #leading_whitespace

      -- Record the difference between consecutive indent levels
      if space_count > 0 and space_count ~= prev_indent_level then
        local diff = math.abs(space_count - prev_indent_level)
        if diff > 0 and diff <= 8 then
          indent_differences[diff] = (indent_differences[diff] or 0) + 1
        end
        prev_indent_level = space_count
      end

      result.space_indent_count = result.space_indent_count + 1

      -- Also track raw indent sizes for fallback
      if space_count > 0 and space_count <= 8 then
        result.indent_sizes[space_count] = (result.indent_sizes[space_count] or 0) + 1
      end
    end

    ::continue::
  end

  -- Find the most common indent difference, which is likely the indentation size
  local max_diff_count = 0
  local likely_indent_size = 0

  for diff, count in pairs(indent_differences) do
    if count > max_diff_count then
      max_diff_count = count
      likely_indent_size = diff
    end
  end

  -- If we found a clear pattern in the differences, use that
  if likely_indent_size > 0 then
    result.most_common_size = likely_indent_size
  else
    -- Otherwise fall back to the most common absolute indent size
    local max_count = 0
    for size, count in pairs(result.indent_sizes) do
      if count > max_count then
        max_count = count
        result.most_common_size = size
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
    vim.notify("Detected tab indentation", vim.log.levels.DEBUG)
  else
    -- Spaces are more common - use spaces
    vim.bo[buf].expandtab = true

    -- Use the most common indent size already tracked during analysis
    local indent_size = analysis.most_common_size

    -- Default to 4 if no clear pattern was found
    if indent_size == 0 then
      indent_size = 4
    end

    -- Apply detected indent size
    vim.bo[buf].tabstop = indent_size
    vim.bo[buf].shiftwidth = indent_size
    vim.bo[buf].softtabstop = indent_size

    vim.notify("Detected space indentation: " .. indent_size .. " spaces", vim.log.levels.DEBUG)
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
  -- vim.api.nvim_create_autocmd("BufReadPost", {
  --   group = vim.api.nvim_create_augroup("DetectIndent", { clear = true }),
  --   callback = function(args)
  --     M.detect_indent(args.buf)
  --   end,
  -- })

  return M
end

return M
