return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
			'debugloop/telescope-undo.nvim'
		},
		keys = function()
			local telescope = require('telescope')
			local builtin = require('telescope.builtin')

			return {
				{ '<leader>ff', builtin.find_files },
				{ '<leader>fg', builtin.live_grep },
				{ '<leader>fb', builtin.buffers },
				{ '<leader>fs', telescope.extensions.file_browser.file_browser },
				{ '<leader>u', '<cmd>Telescope undo<CR>' }
			}
		end,
		config = function()
			local telescope = require('telescope')

			telescope.setup({
				extensions = {
					file_browser = {
						layout_config = {
							preview_width = 0.5
						}
					}
				}
			})

			telescope.load_extension('file_browser')
			telescope.load_extension('undo')
		end
	}
}
