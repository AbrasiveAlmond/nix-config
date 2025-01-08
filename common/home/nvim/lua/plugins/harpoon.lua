return {
	--[[ {
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function()
			local ui = require("harpoon.ui")
			local mark = require("harpoon.mark")

			return {
				-- leader + right hand home row keys for files 1-4
				{ "<leader>n", function() ui.nav_file(1) end },
				{ "<leader>e", function() ui.nav_file(2) end },
				{ "<leader>i", function() ui.nav_file(3) end },
				{ "<leader>o", function() ui.nav_file(4) end },

				-- can't seem to use ctrl+shift because C-S-N opens a new kitty window
				{ "<C-A-N>", function() ui.nav_next() end },
				{ "<C-A-P>", function() ui.nav_prev() end },

				{ "<leader>a", function() mark.add_file() end },
				{ "<leader>h", function() ui.toggle_quick_menu() end }
			}
		end
	} ]]
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function()
			local harpoon = require("harpoon")

			local window_opts = {
				border = "rounded",
				title_pos = "center"
			}

			return {
				-- leader + right hand home row keys for files 1-4
				{ "<leader>n", function() harpoon:list():select(1) end },
				{ "<leader>e", function() harpoon:list():select(2) end },
				{ "<leader>i", function() harpoon:list():select(3) end },
				{ "<leader>o", function() harpoon:list():select(4) end },

				-- can't seem to use ctrl+shift because C-S-N opens a new kitty window
				{ "<C-A-N>", function() harpoon:list():next() end },
				{ "<C-A-P>", function() harpoon:list():prev() end },

				{ "<leader>a", function() harpoon:list():add() end },
				{ "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list(), window_opts) end }
			}
		end,
		config = function()
			require("harpoon"):setup()
		end
	}
}
