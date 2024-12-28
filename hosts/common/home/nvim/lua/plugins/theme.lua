return {
	{
		--[[ "rose-pine/neovim",
		name = "rose-pine",
		opts = {
			highlight_groups = {
				NormalFloat = { bg = "base" },
				FloatBorder = { bg = "base" },
				TelescopeBorder = { bg = "base" }
			}
		} ]]

		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night";
			on_highlights = function(hl, c)
				local normal = { bg = c.bg }
				local border = {
					bg = c.bg,
					fg = c.fg_gutter
				}

				hl.TelescopeNormal = normal
				hl.TelescopeBorder = border
				hl.TelescopePromptNormal = normal
				hl.TelescopePromptBorder = border
				hl.TelescopePromptTitle = border

				hl.NormalFloat = normal
				hl.FloatBorder = border
			end
		}
	}
}
