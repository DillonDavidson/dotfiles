local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>z", "<cmd>set foldmethod=indent<CR>", { desc = "Set foldmethod to indent" })

local Terminal = require("toggleterm.terminal").Terminal
local float_term = Terminal:new({
	direction = "float",
	float_opts = {
		border = "single",
		width = function()
			return math.floor(vim.o.columns * 1.0)
		end,
		height = function()
			return math.floor(vim.o.lines * 1.0)
		end,
		row = function()
			return math.floor(vim.o.lines * 0.35)
		end,
		col = function()
			return math.floor(vim.o.columns * 0.35)
		end,
	},
	hidden = true, -- keeps it persistent across toggles
})

map({ "n", "t" }, "<A-i>", function()
	float_term:toggle()
end, { desc = "Toggle floating term" })

-- Initialize a flag to track the diagnostics state
local diagnostics_active = true
local function toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.enable()
		vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
	else
		vim.diagnostic.enable(false)
		vim.notify("LSP diagnostics disabled", vim.log.levels.WARN)
	end
end

map("n", "<leader>tl", toggle_diagnostics, { noremap = true, silent = true, desc = "[T]oggle [L]SP diagnostics" })

-- map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
-- map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Stuff I stole from NvChad

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Comments
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
