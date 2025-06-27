local M = {}

M.prompt = [[
Write a conventional commits style (https://www.conventionalcommits.org/en/v1.0.0/) commit message for my changes. Please create only the code block without further explanations.

**Requirements:**

- Title: under 50 characters and talk imperative. Follow this rule: If applied, this commit will <commit message>
- Body: wrap at 72 characters
- Include essential information only
- Format as `gitcommit` code block
- Prepend a header with the lines to replace. It should only replace the lines in font of the first comment.
- Use `{scope}` as the scope. If the scope is empty then skip it. If it includes a `#`, also add it in the scope.
- End the commit body with a newline followed by 52 hyphens as a comment starting with `#`.
- Add some usefull comments about the code after the ruler as a comment
-- Is debbuging output in the newly added code. If so, add the files and line number or write `None`.
-- Possible errors introduced by the newly created code
-- Possible optimizations that should be added to the new code
-- It is not allowed to have any multiline code in this comment. Always refer to files and their line number.

Use the following example as reference. Do only use it to understand the format but dont use the information of it.

```gitcommit
feat({scope}): add login functionality

Implement user authentication flow with proper validation
and error handling. Connects to the auth API endpoint.

# --------------------------------------------------
# Debugging Output:
# - [main.js:34](./src/main.js:34): Usage of `debugger` statement.
# - [compiler.js:528](./src/compiler.js:528): Usage of `console.log`.
#
# Possible Issues:
# - [main.js:45](./src/main.js:45): Missing check for `null`.
#
# Possible Optimizations:
# - [main.js:156](./src/main.js:156): Use `let` instead of `var`
# - [main.js:195](./src/main.js:195): Optimize the data structure to improve performance
#
```

Only create the commit message. Do not explain anything!
]]

local function get_commit_scope()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  local scope = ""
  if branch ~= "main" and branch ~= "develop" then
    scope = branch:match("^[^/]+/(.+)")

    if scope and scope:match("%-") then
      local ticket_num = scope:match("^(%d+)%-?")
      if ticket_num then
        scope = "#" .. ticket_num
      else
        local jira_ticket = scope:match("^([A-Z]+%-[0-9]+)%-?")
        if jira_ticket then
          scope = jira_ticket
        else
          scope = "#" .. scope:match("^([^-]+)")
        end
      end
    end
  end

  return scope
end

function M.build_prompt()
  local prompt = M.prompt

  local scope = get_commit_scope()
  prompt = prompt:gsub("{scope}", scope or "")

  return {
    prompt = prompt,
    model = "gpt-4.1",
    context = {
      "git:staged",
      "file:`.git/COMMIT_EDITMSG`",
    },
  }
end

return M
