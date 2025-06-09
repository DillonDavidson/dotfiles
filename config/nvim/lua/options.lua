require("nvchad.options")

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

-- o.cursorlineopt ='both' -- to enable cursorline!

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])
