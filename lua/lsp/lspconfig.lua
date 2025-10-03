-- lua/lsp/lspconfig.lua
-- Modern nvim-lspconfig configuration compatible with latest LazyVim API
return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"mason.nvim",
			{
				"mason-org/mason-lspconfig.nvim",
				config = function() end,
			}, -- Schema support
			"b0o/schemastore.nvim",
		},
		opts = function()
			---@class PluginLspOpts
			local ret = {
				-- options for vim.diagnostic.config()
				---@type vim.diagnostic.Opts
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					severity_sort = true,
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = "󰅚",
							[vim.diagnostic.severity.WARN] = "󰀪",
							[vim.diagnostic.severity.HINT] = "󰌶",
							[vim.diagnostic.severity.INFO] = "󰋽",
						},
					},
					float = {
						focusable = false,
						style = "minimal",
						border = "rounded",
						source = "always",
						header = "",
						prefix = "",
					},
				},

				-- Enable inlay hints
				inlay_hints = {
					enabled = true,
					exclude = { "vue" },
				},

				-- Enable code lenses
				codelens = {
					enabled = false,
				},

				-- Enable LSP folding
				folds = {
					enabled = true,
				},

				-- Global capabilities
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},

				-- Format options
				format = {
					formatting_options = nil,
					timeout_ms = nil,
				},

				-- LSP Server Settings
				---@type table<string, lazyvim.lsp.Config|boolean>
				servers = {
					-- Lua
					lua_ls = {
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								codeLens = {
									enable = true,
								},
								completion = {
									callSnippet = "Replace",
								},
								doc = {
									privateName = { "^_" },
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
							},
						},
					},

					-- TypeScript/JavaScript
					ts_ls = {
						settings = {
							typescript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
							javascript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
						},
					},

					-- Python
					pyright = {
						settings = {
							python = {
								analysis = {
									autoSearchPaths = true,
									diagnosticMode = "workspace",
									useLibraryCodeForTypes = true,
								},
							},
						},
					},

					-- Rust
					rust_analyzer = {
						settings = {
							["rust-analyzer"] = {
								cargo = {
									allFeatures = true,
								},
								checkOnSave = {
									command = "clippy",
								},
								procMacro = {
									enable = true,
								},
								inlayHints = {
									bindingModeHints = {
										enable = false,
									},
									chainingHints = {
										enable = true,
									},
									closingBraceHints = {
										enable = true,
										minLines = 25,
									},
									closureReturnTypeHints = {
										enable = "never",
									},
									lifetimeElisionHints = {
										enable = "never",
										useParameterNames = false,
									},
									maxLength = 25,
									parameterHints = {
										enable = true,
									},
									reborrowHints = {
										enable = "never",
									},
									renderColons = true,
									typeHints = {
										enable = true,
										hideClosureInitialization = false,
										hideNamedConstructor = false,
									},
								},
							},
						},
					},

					-- Go
					gopls = {
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
								},
								staticcheck = true,
								gofumpt = true,
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									compositeLiteralTypes = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
							},
						},
					},

					-- JSON
					jsonls = {
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = {
									enable = true,
								},
							},
						},
					},

					-- YAML
					yamlls = {
						settings = {
							yaml = {
								schemaStore = {
									enable = false,
									url = "",
								},
								schemas = require("schemastore").yaml.schemas(),
							},
						},
					},

					-- CSS
					cssls = {},

					-- HTML
					html = {
						filetypes = { "html", "twig", "hbs" },
					},

					-- Tailwind CSS
					tailwindcss = {
						filetypes = {
							"html",
							"css",
							"scss",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"svelte",
						},
					},

					-- Docker
					dockerls = {},

					-- Bash
					bashls = {},

					-- C/C++
					clangd = {
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--header-insertion=iwyu",
							"--completion-style=detailed",
							"--function-arg-placeholders",
							"--fallback-style=llvm",
						},
						init_options = {
							usePlaceholders = true,
							completeUnimported = true,
							clangdFileStatus = true,
						},
					},

					-- Markdown
					marksman = {},

					-- TOML
					taplo = {},

					-- SQL
					sqlls = {},

					-- Emmet
					emmet_ls = {
						filetypes = {
							"html",
							"css",
							"scss",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
						},
					},
				},

				-- Custom setup functions
				setup = {
					-- Add any custom setup functions here
					-- Example:
					-- rust_analyzer = function(_, opts)
					--   require("rust-tools").setup({ server = opts })
					--   return true
					-- end,
				},
			}
			return ret
		end,

		---@param opts PluginLspOpts
		config = vim.schedule_wrap(function(_, opts)
			-- This handles the modern LazyVim LSP setup
			-- Most of the configuration is handled through the opts function above

			-- Setup autoformat (if LazyVim is available)
			if LazyVim and LazyVim.format then
				LazyVim.format.register(LazyVim.lsp.formatter())
			end

			-- Setup keymaps (if LazyVim is available)
			if LazyVim and LazyVim.lsp then
				LazyVim.lsp.on_attach(function(client, buffer)
					-- Custom keymaps
					local opts_keymap = {
						buffer = buffer,
						silent = true,
					}

					-- Navigation
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts_keymap)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts_keymap)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts_keymap)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts_keymap)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts_keymap)

					-- Documentation
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts_keymap)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts_keymap)

					-- Code actions
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts_keymap)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_keymap)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({
							async = true,
						})
					end, opts_keymap)

					-- Diagnostics
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts_keymap)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts_keymap)
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts_keymap)
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts_keymap)

					-- Document highlighting
					if client.server_capabilities.documentHighlightProvider then
						local group = vim.api.nvim_create_augroup("lsp_document_highlight", {
							clear = false,
						})
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = buffer,
							group = group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd("CursorMoved", {
							buffer = buffer,
							group = group,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end)

				LazyVim.lsp.setup()
				LazyVim.lsp.on_dynamic_capability(function(client, buffer)
					-- Handle dynamic capabilities
				end)
			else
				-- Fallback for non-LazyVim setups
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				local on_attach = function(client, bufnr)
					local opts_keymap = {
						buffer = bufnr,
						silent = true,
					}

					-- Add your keymaps here (same as above)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts_keymap)
					-- ... (rest of the keymaps)
				end

				-- Setup each server
				for server, config in pairs(opts.servers) do
					if config ~= false then
						local server_opts = vim.tbl_deep_extend("force", {
							capabilities = capabilities,
							on_attach = on_attach,
						}, config or {})

						require("lspconfig")[server].setup(server_opts)
					end
				end
			end

			-- Handle inlay hints
			if opts.inlay_hints.enabled then
				if LazyVim and LazyVim.lsp then
					LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
						if
							vim.api.nvim_buf_is_valid(buffer)
							and vim.bo[buffer].buftype == ""
							and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
						then
							vim.lsp.inlay_hint.enable(true, {
								bufnr = buffer,
							})
						end
					end)
				end
			end

			-- Handle folds
			if opts.folds.enabled then
				if LazyVim and LazyVim.lsp then
					LazyVim.lsp.on_supports_method("textDocument/foldingRange", function(client, buffer)
						vim.o.foldmethod = "expr"
						vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
					end)
				end
			end

			-- Handle code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				if LazyVim and LazyVim.lsp then
					LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
						vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buffer,
							callback = vim.lsp.codelens.refresh,
						})
					end)
				end
			end

			-- Configure diagnostics
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			-- Configure LSP handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			-- Setup capabilities
			if opts.capabilities then
				if vim.lsp.config then
					vim.lsp.config("*", {
						capabilities = opts.capabilities,
					})
				end
			end

			-- Get all the servers that are available through mason-lspconfig
			local have_mason = LazyVim and LazyVim.has and LazyVim.has("mason-lspconfig.nvim")
			local mason_all = have_mason
					and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
				or {} --[[ @as string[] ]]
			local mason_exclude = {} ---@type string[]

			---@return boolean? exclude automatic setup
			local function configure(server)
				local sopts = opts.servers[server]
				sopts = sopts == true and {} or (not sopts) and {
					enabled = false,
				} or sopts --[[@as lazyvim.lsp.Config]]

				if sopts.enabled == false then
					mason_exclude[#mason_exclude + 1] = server
					return
				end

				local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
				local setup = opts.setup[server] or opts.setup["*"]
				if setup and setup(server, sopts) then
					mason_exclude[#mason_exclude + 1] = server
				else
					-- Use the new vim.lsp.config API if available, otherwise fall back to lspconfig
					if vim.lsp.config then
						vim.lsp.config(server, sopts)
					else
						-- Fallback for older Neovim versions or non-LazyVim setups
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						local on_attach = function(client, bufnr)
							-- Add keymaps here if needed
						end

						local server_config = vim.tbl_deep_extend("force", {
							capabilities = capabilities,
							on_attach = on_attach,
						}, sopts or {})

						require("lspconfig")[server].setup(server_config)
					end

					if not use_mason and vim.lsp.enable then
						vim.lsp.enable(server)
					end
				end
				return use_mason
			end

			local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))

			if have_mason then
				require("mason-lspconfig").setup({
					ensure_installed = vim.list_extend(
						install,
						LazyVim.opts and LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
					),
					automatic_installation = true,
				})
			end
		end),
	},
}
