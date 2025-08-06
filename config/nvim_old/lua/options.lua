require("nvchad.options")

-- add yours here!

local o = vim.o

-- Indenting
o.expandtab = false
o.shiftwidth = 8
o.tabstop = 8
o.softtabstop = 8

vim.filetype.add({
	extension = {
		cu = "cuda",
		cuh = "cuda",
	},
})

-- Use indent-based folding
vim.opt.foldmethod = "indent"

-- Only save/restore folds when switching tabs/windows
vim.api.nvim_create_augroup("remember_folds", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
	group = "remember_folds",
	pattern = "*",
	command = "silent! mkview",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = "remember_folds",
	pattern = "*",
	command = "silent! loadview",
})

-- vim.opt.foldmethod = "indent"
-- vim.opt.foldenable = true
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 99

-- o.cursorlineopt ='both' -- to enable cursorline!
