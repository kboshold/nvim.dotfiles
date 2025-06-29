# Project Specification: Smart Commit for Neovim (v2.0)

- **Project Name**: `kboshold.features.smart-commit`
- **Author**: kboshold
- **Document Version**: 2.0
- **Generated On**: 2025-06-29 08:45:45 UTC

## 1. Vision & Overview

The "Smart Commit" plugin for Neovim 0.11+ is envisioned as an intelligent, automated assistant for the Git commit process. It aims to streamline the developer's workflow by running a configurable pipeline of tasks—such as linters, testers, and AI-powered analyzers—in the background the moment a commit buffer is opened.

By leveraging Neovim 0.11's modern asynchronous APIs (`vim.system`) and providing rich, real-time feedback through a non-intrusive "sticky header" UI, the plugin will provide immediate insights into staged changes, catch errors early, and even assist in writing commit messages, all without blocking the user.

## 2. Core Functionality

- **Event-Driven Activation**: Automatically triggers its pipeline when a `COMMIT_EDITMSG` buffer is opened.
- **Hierarchical & Extendable Configuration**: Merges configuration from plugin defaults, user-level, project-level, and setup-time calls. Allows users to easily extend and override predefined tasks.
- **Asynchronous Task Runner**: Executes tasks in parallel using a dependency-aware (DAG) engine, ensuring the Neovim UI remains fully responsive.
- **Real-time UI Feedback**: Displays task progress, status (running, success, failure), and output in a dedicated "sticky header" split and via sign column indicators.
- **Extensible by Design**: Provides a public API for users and other plugins to register their own custom tasks.
- **Environment-Aware**: Can be disabled on-the-fly for specific commits using an environment variable (`SMART_COMMIT_ENABLED=0`).

## 3. Type Definitions (`types.lua`)

To ensure type safety and provide first-class LSP support via EmmyLua/LuaLS, all core data structures will be defined in a central `lua/kboshold/features/smart-commit/types.lua` file.

```lua
-- types.lua

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

return M
```

## 4. Configuration System (`config.lua`)

### 4.1. Loading Mechanism

Configuration shall be loaded and merged in the following order of precedence (where each step overrides the previous):

1.  **Plugin Defaults**: The base configuration, including a set of predefined tasks, defined within the plugin itself.
2.  **User Global Config**: A `.smart-commit.lua` file in the user's Neovim config directory (`vim.fn.stdpath('config')`).
3.  **Project-Specific Config**: The first `.smart-commit.lua` file found when traversing from the current working directory up to the filesystem root.
4.  **Runtime Setup**: The Lua table passed to the `require('...').setup({})` function.

### 4.2. Simplified User Configuration

The `.smart-commit.lua` files are designed to be simple and declarative. They **must not** require any other modules and should only return a static Lua table that conforms to the `SmartCommitConfig` type.

**Example `.smart-commit.lua`:**

```lua
-- ~/.config/nvim/.smart-commit.lua
-- No `require` needed. Just return a table.

return {
  defaults = {
    concurrency = 8,
  },
  tasks = {
    -- Extend a predefined task to override its label
    ["pnpm-lint"] = {
      extend = "pnpm-lint", -- This is a predefined task ID
      label = "Linting (Project Specific)",
    },
    -- Define a completely new, custom task for this project
    ["run-db-check"] = {
      id = "run-db-check",
      label = "Check Database Schema",
      command = "scripts/check_db.sh",
      icon = "󰆼",
    },
    -- Disable a predefined task for this project
    ["analyze-staged"] = false,
  },
}
```

## 5. Asynchronous Task Engine (`runner.lua`)

The core of the plugin. It must orchestrate task execution without blocking the user.

- **Execution Flow**:
    1.  **Trigger**: An autocommand on `BufEnter` for `COMMIT_EDITMSG` initiates the process.
    2.  **Pre-flight Checks**: Verifies `SMART_COMMIT_ENABLED` and `config.auto_run`.
    3.  **Task Resolution**: The final list of tasks is built by merging user configs over the plugin's predefined tasks. Tasks with an `extend` property are merged with their base definition, and any task set to `false` is removed.
    4.  **Task Filtering**: Evaluates the `when()` condition for each resolved task to build the list of tasks to run.
    5.  **Dependency Resolution**: Constructs a Directed Acyclic Graph (DAG) to determine execution order.
    6.  **Execution**: Runs tasks with no pending dependencies in parallel, respecting the `concurrency` limit. It must use `vim.system()` for non-blocking execution of shell commands.
    7.  **State Updates**: As tasks complete, their state (`running`, `success`, `failed`, `cancelled`) is updated. The engine then queues up dependent tasks whose prerequisites are now met.
    8.  **Safe UI Updates**: All calls to the UI module must be wrapped in `vim.schedule()` to ensure they are executed safely on the main Neovim thread.

## 6. UI/UX Components (`ui.lua`)

### 6.1. Sign Column Indicators

- Define signs via `vim.fn.sign_define()` for task states:
    - **Running**: An animated spinner (e.g., `|`, `/`, `-`, `\`).
    - **Failed**: An error icon (e.g., `✗`, `nf-fa-times`).
    - **Successful**: A success icon (e.g., `✓`, `nf-fa-check`).
- Signs will be placed in the `COMMIT_EDITMSG` buffer and updated in real-time.

### 6.2. Sticky Header (Status Window)

This component is the primary feedback mechanism. It must be implemented as a dedicated split window that pushes the main buffer's content, never obscuring it.

#### 6.2.1. Core Behavior

- **Window Handling**: The header must be created as a new split relative to the target window (`target_win_id`). This ensures it correctly respects existing vertical or horizontal splits, only spanning the dimensions of the target window.
- **Dynamic Resizing**: The header split must automatically resize its height to perfectly match its content. If the content changes from 3 lines to 1, the split must shrink accordingly.
- **Viewport Preservation**: After creating or resizing the header, the original viewport of the target window must be restored. The line at the top of the window must remain the line at the top of the window.

#### 6.2.2. Data Structures & Types

```lua
--- A chunk of text with an associated highlight group.
--- @class StickyHeaderChunk
--- @field text string The text to display.
--- @field highlight_group string The highlight group to apply to the text.

--- A single line in the header, composed of multiple text chunks.
--- @alias StickyHeaderLine StickyHeaderChunk[]

--- The entire content for the sticky header.
--- @alias StickyHeaderContent StickyHeaderLine[]

--- Internal state of a header instance.
--- @class StickyHeaderState
--- @field header_win_id number The window ID of the header split.
--- @field header_buf_id number The buffer ID of the header split.
--- @field target_win_id number The window ID of the buffer the header is attached to.
--- @field is_visible boolean
```

#### 6.2.3. Module API (`ui.lua`)

The module must be stateless and operate only on the `target_win_id` provided.

```lua
---@class SmartCommitUI
local M = {}

--- Sets or updates the header content for a given window.
--- Creates the header if it doesn't exist.
---@param target_win_id number The window to attach the header to.
---@param content StickyHeaderContent The content to display.
function M.set(target_win_id, content) end

--- Toggles the header's visibility for a given window.
---@param target_win_id number The window where the header is attached.
---@param content StickyHeaderContent The content to display if showing the header.
function M.toggle(target_win_id, content) end

return M
```

## 7. Predefined Tasks (`predefined/`)

### 7.1. Generate Commit Message (Copilot & Commitizen)

- **ID**: `generate-commit-message`
- **Functionality**: This task automates the creation of a structured commit message following the **Commitizen** convention. It intelligently parses the current Git branch to determine the commit `type` and `scope`, then prompts Copilot to generate a fitting subject and body.

- **Execution Flow**:
    1.  **Get Current Branch**: Retrieve the current Git branch name (e.g., via `git rev-parse --abbrev-ref HEAD`).
    2.  **Parse Branch for Type and Scope**:
        - The function will attempt to parse the branch name using a regex like `^(feat|feature|bugfix|hotfix)\/([a-zA-Z0-9_-]+)`.
        - **Type**: The first capture group (`feat`, `feature`, `bugfix`, `hotfix`) determines the commit type. `feature` should be normalized to `feat`.
        - **Scope**: The second capture group is the scope.
            - If the scope is purely numeric (e.g., `12345`), it should be formatted as `(#12345)` to link to a GitHub issue.
            - Otherwise, the scope is used as-is (e.g., `(some-scope)`).
        - **No Match / Main Branch**: If the branch is `main` or does not match the pattern, the commit will have no scope, and the type will default to `feat`.
    3.  **Construct Commit Prefix**: Assemble the commit prefix (e.g., `feat(#123): ` or `fix(auth): ` or `feat: `).
    4.  **Prompt Copilot**: Programmatically invoke `CopilotChat.nvim` with a prompt that includes the staged changes and instructs it to generate a subject and body for the commit, given the predetermined prefix.
        - _Example Prompt_: "Given the commit prefix `feat(#42):`, write a concise and informative commit message subject and body based on the following staged changes: [staged diff here]".
    5.  **Insert into Buffer**: The final, assembled message (`prefix` + `generated subject/body`) is inserted into the `COMMIT_EDITMSG` buffer.

### 7.2. Analyze Staged Changes (Copilot)

- **ID**: `analyze-staged`
- **Functionality**: Uses a Copilot prompt to analyze staged code for potential issues (debug statements, commented-out code, obvious errors). The resulting summary is displayed in the sticky header.

### 7.3. PNPM Task Factory (`pnpm.lua`)

- **Function**: `create_pnpm_task(cmd, opts)`
- **Updated Functionality**: The factory will now incorporate a memoization mechanism to ensure that prerequisite checks are run efficiently.
- **Execution Logic**:
    1.  A session-local flag, e.g., `_pnpm_install_checked`, will be used to track if `pnpm install` has been attempted.
    2.  For any task created by this factory, the `command` function will first check this flag.
    3.  If the flag is not set, it will:
        - Check for the existence of `node_modules`.
        - If `node_modules` is absent, it will run `pnpm install`.
        - Set the `_pnpm_install_checked` flag to `true` for the current session, regardless of the outcome.
    4.  Subsequent `pnpm` tasks in the same run will see the flag is set and **skip** the `node_modules` check entirely.
    5.  After the install check, it verifies the script exists in `package.json` before executing it.
- **Benefit**: This ensures that when multiple pnpm tasks are defined (e.g., `pnpm-lint`, `pnpm-test`, `pnpm-build`), the potentially slow `pnpm install` command is **only ever run once** at the beginning of the process, if needed.

## 8. API and Extensibility

- A public function, `require('kboshold.features.smart-commit').register_task(task_table)`, must be exposed to allow users and other plugins to programmatically register new tasks that conform to the `SmartCommitTask` type. This is an alternative to static configuration for more dynamic integrations.

## 9. File Structure

```
kboshold.features.smart-commit/
├── lua/
│   └── kboshold/
│       └── features/
│           └── smart-commit/
│               ├── init.lua            # Main entry point, setup(), register_task() API
│               ├── config.lua          # Configuration loading, merging, and extending logic
│               ├── runner.lua          # Core async task runner and dependency graph
│               ├── task.lua            # Task class/object definition and state
│               ├── ui.lua              # Sticky Header API, sign column management
│               ├── types.lua           # Centralized EmmyLua/LuaLS type definitions
│               ├── predefined/         # Directory for built-in tasks
│               │   ├── init.lua        # Exposes the predefined tasks to the config
│               │   ├── copilot.lua     # Copilot-related tasks
│               │   └── pnpm.lua        # PNPM factory function with memoization
│               └── utils.lua           # General utility functions (e.g., find file up, git branch)
└── README.md                           # Comprehensive user documentation
```

## 10. Documentation

- **README.md**: Must be updated to reflect the new configuration system. It should clearly explain the concept of `predefined_tasks` and how to use the `extend` property. Examples for `.smart-commit.lua` and `setup()` must be provided.
- **Inline Documentation**: All public and internal functions, classes, and types must have meticulous EmmyLua/LuaLS annotations, sourcing types from the central `types.lua` file.

## 11. Configs

- Provide me with the Plugin config for lazy.nvim
- Provide me with a `.smart-commit.lua` with two tasks that extends the `pnpm` task and run `pnpm lint` and `pnpm prisma generate`. Also add a task extending `pnpm` which runs `pnpm typecheck` and depends_on `pnpm prisma_generate`.
