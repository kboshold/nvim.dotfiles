-- Smart Commit Type Definitions
-- Author: kboshold

local M = {}

---@class SmartCommitStatusWindowConfig
---@field enabled? boolean # Show status window. Default: true.
---@field position? "bottom" | "top" # Position of the header split. Default: 'bottom'.
---@field refresh_rate? number # UI refresh rate in milliseconds. Default: 100.

---@class SmartCommitDefaults
---@field cwd? string # Default working directory for tasks. Default: vim.fn.getcwd().
---@field timeout? number # Default task timeout in ms. Default: 30000.
---@field concurrency? number # Max number of concurrent tasks. Default: 4.
---@field auto_run? boolean # Automatically run on commit message buffer open. Default: true.
---@field sign_column? boolean # Show signs in the sign column. Default: true.
---@field status_window? SmartCommitStatusWindowConfig

---@alias TaskFn fun():(boolean | {ok: boolean, message: string})
---@alias ConditionFn fun():boolean
---@alias ErrorHandlerFn fun(err: string)
---@alias SuccessHandlerFn fun(result: any)

---@class SmartCommitTask
---@field id string # Required, unique identifier for the task.
---@field label string # Human-readable name for the UI.
---@field extend? string # ID of a predefined task to extend. Overrides properties from the base task.
---@field icon? string # Icon to display (Nerd Font recommended).
---@field command? string | fun():string # Shell command to execute.
---@field fn? TaskFn # Lua function to execute. (Alternative to 'command').
---@field cwd? string # Working directory for this specific task.
---@field when? ConditionFn # Function to determine if the task should run. Must return true for the task to be scheduled.
---@field timeout? number # Timeout in milliseconds for this task.
---@field depends_on? string[] # List of task 'id's that must complete successfully first.
---@field on_error? ErrorHandlerFn # Callback for when the task fails.
---@field on_success? SuccessHandlerFn # Callback for when the task succeeds.
---@field env? table<string, string> # Environment variables for the task's command.

---@class SmartCommitConfig
---@field defaults? SmartCommitDefaults
---@field tasks? table<string, SmartCommitTask | false> # A map of task configurations. Setting a task to `false` disables it.

--- A chunk of text with an associated highlight group.
---@class StickyHeaderChunk
---@field text string The text to display.
---@field highlight_group string The highlight group to apply to the text.

--- A single line in the header, composed of multiple text chunks.
---@alias StickyHeaderLine StickyHeaderChunk[]

--- The entire content for the sticky header.
---@alias StickyHeaderContent StickyHeaderLine[]

--- Internal state of a header instance.
---@class StickyHeaderState
---@field header_win_id number The window ID of the header split.
---@field header_buf_id number The buffer ID of the header split.
---@field target_win_id number The window ID of the buffer the header is attached to.
---@field is_visible boolean

return M
