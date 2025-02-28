return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim"
	},
	config = function()
		local lspconfig = require("lspconfig");

		local function get_virtual_text_config()
			local width = vim.api.nvim_win_get_width(0)
			local virtual_text = {
				prefix = '▎',
				spacing = 0
			}

			if width > 150 then
				virtual_text.virt_text_pos = 'inline'
				virtual_text.virt_text_win_col = 120
			elseif width > 130 then
				virtual_text.virt_text_pos = 'inline'
				virtual_text.virt_text_win_col = 100
			else 
				virtual_text.virt_text_pos = 'eol'
				virtual_text.spacing = 4
			end

			return virtual_text
		end

		-- Basic diagnostic config
		vim.diagnostic.config({
			underline = true,
			update_in_insert = true,
			severity_sort = true,
			virtual_text = get_virtual_text_config(),
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = '󰅚',
					[vim.diagnostic.severity.WARN] = '󰀪',
					[vim.diagnostic.severity.HINT] = '󰌶',
					[vim.diagnostic.severity.INFO] = ''
				},
			},
			inlay_hints = { enabled = true },
			codelens = { enabled = false },
			document_highlight = { enabled = true },
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
		});

		-- Cache capabilities
		local capabilities = (function()
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			return vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {}
			)
		end)()

		-- Common on_attach function
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

		-- Server configurations
		local servers = {
			rust_analyzer = {},
			angularls = {},
			ansiblels = {},
			bashls = {},
			cssls = {},
			yamlls = {},
			astro = {},
			denols = {
				root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
			},
			ts_ls = {
				root_dir = lspconfig.util.root_pattern("package.json"),
				single_file_support = false
			},
			lua_ls = {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
						runtime = {
							version = 'LuaJIT'
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library"
							}
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
			}
		}

		-- Lazy load servers based on file type
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("LspAttach_" .. vim.api.nvim_win_get_number(0), { clear = true }),
			callback = function(args)
				local ft = args.match
				local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
				
				-- Skip if LSP is already attached
				if #clients > 0 then return end

				-- Map filetypes to server names
				local ft_servers = {
					rust = "rust_analyzer",
					typescript = "ts_ls",
					javascript = "ts_ls",
					lua = "lua_ls",
					yaml = "yamlls",
					css = "cssls",
					html = "html",
					sh = "bashls",
					bash = "bashls",
					astro = "astro",
					angular = "angularls",
					ansible = "ansiblels",
				}

				local server_name = ft_servers[ft]
				if server_name then
					local server_config = servers[server_name] or {}
					local final_config = vim.tbl_deep_extend("force", {
						capabilities = capabilities,
						on_attach = on_attach,
					}, server_config)

					lspconfig[server_name].setup(final_config)
				end
			end,
		})

		-- Window resize handler with debounce
		local resize_timer = nil
		vim.api.nvim_create_autocmd("VimResized", {
			group = vim.api.nvim_create_augroup("LspConfigResize", { clear = true }),
			callback = function()
				if resize_timer then
					vim.fn.timer_stop(resize_timer)
				end
				resize_timer = vim.fn.timer_start(100, function()
					vim.diagnostic.config({
						virtual_text = get_virtual_text_config(),
					})
				end)
			end,
		})
	end
}
