vim.g.mapleader = " "

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	performance = {
		rtp = {
			disabled_plugins = {
				"netrwPlugin",
				"gzip",
				"tarPlugin",
				"tohtml",
				"zipPlugin"
			}
		}
	}
})

-- apply options and keymappings
require("options")
require("keymap")

vim.cmd("colorscheme tokyonight")
vim.cmd("set spell")

-- do stuff when an lsp attaches
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(event)
		local function bufmap(modes, keys, action)
			vim.keymap.set(modes, keys, action, { buffer = event.buf })
		end

		vim.opt.signcolumn = "yes"

		bufmap("n", "gd", function() vim.lsp.buf.definition() end)
		bufmap("n", "gD", function() vim.lsp.buf.declaration() end)
		bufmap("n", "K", function() vim.lsp.buf.hover() end)
		bufmap("n", "<leader>ca", function() vim.lsp.buf.code_action() end)
		bufmap("n", "<leader>rn", function() vim.lsp.buf.rename() end)
		bufmap("n", "<leader>rr", function() vim.lsp.buf.references() end)
		bufmap("n", "<leader>fm", function() vim.lsp.buf.format() end)
	end
})
