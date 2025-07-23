require "nvchad.options"

-- add yours here!

local o = vim.o

-- Indenting
o.expandtab = false
o.shiftwidth = 8
o.tabstop = 8
o.softtabstop = 8

vim.filetype.add {
    extension = {
        cu = "cuda",
        cuh = "cuda",
    },
}

vim.opt.foldmethod = "indent"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- o.cursorlineopt ='both' -- to enable cursorline!
