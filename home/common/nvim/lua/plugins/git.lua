return {
	{
		"tpope/vim-fugitive",
		lazy = true
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" }
				},
				signs_staged = {
					add = { text = "│" },
					change = { text = "│" }
				}
			})

			vim.keymap.set("n", "[h", gitsigns.prev_hunk)
			vim.keymap.set("n", "]h", gitsigns.next_hunk)
			vim.keymap.set("n", "<leader>gh", gitsigns.preview_hunk_inline)
			vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk)
			vim.keymap.set("n", "<leader>gb", gitsigns.blame_line)
		end
	}
}
