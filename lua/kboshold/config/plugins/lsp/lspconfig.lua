return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim"
	},
	config = function()
		local lspconfig = require("lspconfig");

		vim.diagnostic.config({
			underline = true,
			update_in_insert = true,
			severity_sort = true,
			virtual_text = {
				prefix = '▎',
				spacing = 0,
				virt_text_win_col = 120,
				virt_text_pos = "right_align",
				-- format = function(diagnostic)
				--   return diagnostic.message:gsub("[\n\t]+", " "):gsub("^%s+", ""):gsub("%s+", " ")
				-- end,
			},
			signs = {
				--support diagnostic severity / diagnostic type name
				text = {
					[vim.diagnostic.severity.ERROR] = '󰅚',
					[vim.diagnostic.severity.WARN] = '󰀪',
					[vim.diagnostic.severity.HINT] = '󰌶',
					[vim.diagnostic.severity.INFO] = ''
				},
			},
			inlay_hints = {
				enabled = true,
			},
			codelens = {
				enabled = false,
			},
			document_highlight = {
				enabled = true,
			},
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
		});

		local on_attach = function(_, bufnr)
			local attach_opts = { silent = true, buffer = bufnr }
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
			vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
			vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
			vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
			vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, attach_opts)
			vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
			vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
		end

		-- may enable cmp
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		local capabilities  = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp and cmp_nvim_lsp.default_capabilities() or {}
		)

		local servers = {'rust_analyzer', 'ts_ls', 'angularls', 'ansiblels', 'bashls', 'cssls', 'yamlls' }
		-- local servers = {}
		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup {
				on_attach = on_attach,
				capabilities = capabilities,
			}
		end

		-- Setup lsp servers
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT'
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths here.
							"${3rd}/luv/library"
							-- "${3rd}/busted/library",
						}
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					}
				})
			end,
			settings = {
				Lua = {
					completion = {
						callSnippet = 'Replace',
					},
				}
			}
		})

	end
}
