local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- tabs
opt.tabstop = 4
opt.shiftwidth = 4

-- make key sequences timeout a bit faster
opt.timeoutlen = 700

-- disable the netrw banner (you can still use I to toggle)
vim.g.netrw_banner = 0
