return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{ '<leader>tr', '<cmd>Trouble diagnostics toggle<cr>' },
		{ '<leader>tb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>' },
		{ '<leader>tq', '<cmd>Trouble qflist toggle<cr>' },
		{ '<leader>tl', '<cmd>Trouble loclist toggle<cr>' },
		{ '<leader>td', '<cmd>Trouble lsp toggle focus=false<cr>' },
		{ ']t', '<cmd>Trouble next jump=true<cr>' },
		{ '[t', '<cmd>Trouble prev jump=true<cr>' }
	}
}
