-- Claude Code and Codex prompt files opened via Ctrl+G
local PROMPT_FILE_PATTERNS = {
  "claude%-prompt%-[%w%-]+%.md$",
  "/%.codex/editor/[^/]+%.md$",
}

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml" },
        condition = function(ctx)
          return not vim.iter(PROMPT_FILE_PATTERNS):any(function(pattern)
            return ctx.filename:match(pattern) ~= nil
          end)
        end,
      },
    },
  },
}
