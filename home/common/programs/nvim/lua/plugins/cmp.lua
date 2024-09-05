return {
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets'
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			require('luasnip.loaders.from_vscode').lazy_load()

			cmp.setup({
				sources = {
					{ name = 'path' },
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' }
				},
				mapping = cmp.mapping.preset.insert({
					['<C-f>'] = cmp.mapping(function() luasnip.jump(1) end),
					['<C-b>'] = cmp.mapping(function() luasnip.jump(-1) end),

					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),

					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete()
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				completion = {
					-- idk what this means but it makes it so that the first item is selected automatically
					completeopt = 'menu,menuone,noinsert'
				},
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end
				}
			})
		end
	}
}
