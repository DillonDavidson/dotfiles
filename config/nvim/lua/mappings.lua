require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "-", "<cmd>foldclose<CR>", { desc = "Close code fold" })
map("n", "+", "<cmd>foldopen<CR>", { desc = "Open code fold" })
map(
    "n",
    "<leader>z",
    "<cmd>set foldmethod=indent<CR>",
    { desc = "Set foldmethod to indent" }
)
map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle({
        pos = "float",
        id = "floatTerm",
        float_opts = {
            row = 0.35,
            col = 0.05,
            width = 1.0,
            height = 0.90,
            -- height = 0.5,
        },
    })
end, { desc = "terminal toggle floating term" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
