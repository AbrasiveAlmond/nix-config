return {
	{
		'neovim/nvim-lspconfig',
		event = "BufReadPost",
		dependencies = {
			'hrsh7th/cmp-nvim-lsp'
		},
		config = function()
			local lspconfig = require('lspconfig')

			-- make the background of floating windows the same as the main background
			--[[ vim.api.nvim_create_autocmd('ColorScheme', {
				pattern = '*',
				callback = function()
					vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
				end
			}) ]]

			local border = {
				{ '╭', 'FloatBorder' },
				{ '─', 'FloatBorder' },
				{ '╮', 'FloatBorder' },
				{ '│', 'FloatBorder' },
				{ '╯', 'FloatBorder' },
				{ '─', 'FloatBorder' },
				{ '╰', 'FloatBorder' },
				{ '│', 'FloatBorder' }
			}

			-- override the border for all language servers (taken from https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization)
			local orig_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_open_floating_preview(contents, syntax, opts, ...)
			end

			local default_capabilities = require('cmp_nvim_lsp').default_capabilities()

			local default_setup = {
				capabilities = default_capabilities
			}

			lspconfig.rust_analyzer.setup(default_setup)
			lspconfig.tsserver.setup(default_capabilities)

			lspconfig.lua_ls.setup({
				capabilities = default_capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' }
						}
					}
				}
			})

			lspconfig.nil_ls.setup(default_setup)
			lspconfig.typst_lsp.setup(default_setup)
			lspconfig.vuels.setup(default_setup)
			lspconfig.pyright.setup(default_setup)

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end
	}
}
