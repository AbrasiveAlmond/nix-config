return {
	{
		'altermo/ultimate-autopair.nvim',
		event = { 'InsertEnter', 'CmdlineEnter' },
		branch = 'v0.6',
		config = true
	},
	{
		'windwp/nvim-ts-autotag',
		event = { 'InsertEnter' },
		config = function()
			require('nvim-ts-autotag').setup({
				opts = {
					enable_close_on_slash = true
				}
			})
		end
	}
}
