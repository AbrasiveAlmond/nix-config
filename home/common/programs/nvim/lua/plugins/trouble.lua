return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		icons = false
	},
	config = function()
		local trouble = require('trouble')

		vim.keymap.set('n', '<leader>tw', function() trouble.toggle('workspace_diagnostics') end)
		vim.keymap.set('n', '<leader>td', function() trouble.toggle('document_diagnostics') end)
		vim.keymap.set('n', '<leader>tq', function() trouble.toggle('quickfix') end)
		vim.keymap.set('n', '<leader>tl', function() trouble.toggle('loclist') end)
		vim.keymap.set('n', '<leader>tr', function() trouble.toggle('lsp_references') end)
		vim.keymap.set('n', ']t', function() trouble.next({ skip_groups = true, jump = true }) end)
		vim.keymap.set('n', '[t', function() trouble.previous({ skip_groups = true, jump = true }) end)
	end
}
