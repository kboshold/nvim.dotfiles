-- Vue configuration that adapts to the chosen TypeScript server
local function get_typescript_server()
  if vim.g.typescript_server then
    return vim.g.typescript_server
  end

  local env_server = os.getenv("NVIM_TS_SERVER")
  if env_server then
    return env_server
  end

  return "typescript-tools" -- Default
end

local typescript_server = get_typescript_server()

return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = "vue",
      root = { "vue.config.js" },
    })
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },

  -- Vue LSP configuration that adapts to TypeScript server choice
  {
    "neovim/nvim-lspconfig",
    opts = function()
      if typescript_server == "typescript-tools" then
        -- Configuration for typescript-tools
        return {
          servers = {
            volar = {
              -- Use Take Over Mode with typescript-tools
              init_options = {
                vue = {
                  hybridMode = false,
                },
                typescript = {
                  tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
                },
              },
              filetypes = { "vue" },
            },
          },
        }
      else
        -- Configuration for vtsls (LazyVim default approach)
        return {
          servers = {
            volar = {
              init_options = {
                vue = {
                  hybridMode = true, -- Use hybrid mode with vtsls
                },
              },
              on_init = function(client)
                client.handlers["tsserver/request"] = function(_, result, context)
                  local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
                  if #clients == 0 then
                    vim.notify(
                      "Could not find `vtsls` lsp client, vue_lsp would not work without it.",
                      vim.log.levels.ERROR
                    )
                    return
                  end
                  local ts_client = clients[1]

                  local param = unpack(result)
                  local id, command, payload = unpack(param)
                  ts_client:exec_cmd({
                    command = "typescript.tsserverRequest",
                    arguments = {
                      command,
                      payload,
                    },
                  }, { bufnr = context.bufnr }, function(_, r)
                    local response_data = { { id, r.body } }
                    ---@diagnostic disable-next-line: param-type-mismatch
                    client:notify("tsserver/response", response_data)
                  end)
                end
              end,
            },
            vtsls = {},
          },
        }
      end
    end,
  },

  -- Configure vtsls plugin for Vue when using vtsls
  typescript_server == "vtsls"
      and {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
          table.insert(opts.servers.vtsls.filetypes, "vue")
          LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
            {
              name = "@vue/typescript-plugin",
              location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            },
          })
        end,
      }
    or {},

  -- Ensure typescript-tools loads for Vue files when using typescript-tools
  typescript_server == "typescript-tools"
      and {
        "pmizio/typescript-tools.nvim",
        ft = { "vue" }, -- Add vue to filetypes
      }
    or {},
}
