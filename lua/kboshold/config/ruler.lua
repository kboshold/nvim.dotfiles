-- Thin rulers at 'colorcolumn' positions, drawn as ephemeral extmarks so they
-- are rebuilt on every redraw and can never cover text.
local ns = vim.api.nvim_create_namespace("kboshold_ruler")

local CHAR = "┃"
local HIGHLIGHTS = { "ColorColumnBlue", "ColorColumnRed" }
local EXCLUDE_BUFTYPES = { nofile = true, quickfix = true, terminal = true, prompt = true, help = true }

---@type table<integer, { columns: integer[], leftcol: integer, text_width: integer }>
local windows = {}

local function parse_columns(win, buf)
  local textwidth = vim.bo[buf].textwidth
  local columns = {}
  for _, spec in ipairs(vim.split(vim.wo[win].colorcolumn, ",", { trimempty = true })) do
    local sign, num = spec:match("^([+-]?)(%d+)$")
    num = tonumber(num)
    if num and sign == "" then
      table.insert(columns, num)
    elseif num and textwidth > 0 then
      table.insert(columns, sign == "+" and textwidth + num or textwidth - num)
    end
  end
  return columns
end

local function clear_colorcolumn()
  vim.api.nvim_set_hl(0, "ColorColumn", {})
end

clear_colorcolumn()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("kboshold_ruler", { clear = true }),
  callback = clear_colorcolumn,
})

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, win, buf)
    if EXCLUDE_BUFTYPES[vim.bo[buf].buftype] then
      return false
    end
    local columns = parse_columns(win, buf)
    if #columns == 0 then
      return false
    end
    local info = vim.fn.getwininfo(win)[1]
    windows[win] = {
      columns = columns,
      leftcol = info.leftcol or 0,
      text_width = info.width - info.textoff,
    }
  end,
  on_line = function(_, win, buf, row)
    local state = windows[win]
    if not state then
      return
    end
    local line_width = vim.api.nvim_win_call(win, function()
      return vim.fn.virtcol({ row + 1, "$" }) - 1
    end)
    for i, column in ipairs(state.columns) do
      local win_col = column - 1 - state.leftcol
      -- skip when text reaches the column or the column is outside the visible text area
      if line_width < column and win_col >= 0 and win_col < state.text_width then
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          virt_text = { { CHAR, HIGHLIGHTS[math.min(i, #HIGHLIGHTS)] } },
          virt_text_pos = "overlay",
          virt_text_win_col = win_col,
          hl_mode = "combine",
          priority = 1,
          ephemeral = true,
        })
      end
    end
  end,
})
