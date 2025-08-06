require "nvchad.options"

-- add yours here!

local o = vim.o

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
