return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				options = {
					section_separators = { left = '', right = '' },
					component_separators = ''
				},
				sections = {
					lualine_a = { { 'mode', separator = { left = '', right = '' } } },
					lualine_b = { 'branch', 'diff' },
					lualine_c = { 'file' },
					lualine_x = { 'filetype', 'encoding' },
					lualine_y = { 'progress' },
					lualine_z = { { 'location', separator = { left = '', right = '' } } }
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
