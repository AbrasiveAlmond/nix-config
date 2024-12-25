return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				options = {
					section_separators = { left = '', right = '' },
					component_separators = ''
				},
				sections = {
					lualine_a = { { 'mode' } },
					lualine_b = { 'branch', 'diff' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding' },
					lualine_y = { 'progress' },
					lualine_z = { { 'location' } }
				},
				inactive_sections = {
					lualine_a = { 'filename' },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { 'location' },
				},
				tabline = {},
				extensions = {}
			}
		end
	}
}
