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

local spellcheck_file_types = { "gitcommit", "rust", "c", "typescript", "javascript", "python" }

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Enable spellcheck for certain file types",
  group = vim.api.nvim_create_augroup("spellcheck", { clear = true }),
  pattern = spellcheck_file_types,
  callback = function()
    vim.opt_local.spell = true
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Configure general LSP settings",
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

local small_indent_file_types = { "nix" }

vim.api.nvim_create_autocmd({ "FileType" }, {
	desc = "Reduce indent to 2 spaces in certain file types",
	group = vim.api.nvim_create_augroup("small_indent", { clear = true }),
	pattern = small_indent_file_types,
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end
})
