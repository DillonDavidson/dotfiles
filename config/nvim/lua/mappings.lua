require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      row = 0.35,
      -- row = 1.0,
      col = 0.05,
      -- col = 1.0,
      width = 1.0,
      -- height = 1.0,
      height = 0.90,
      -- height = 0.5,
    },
  }
end, { desc = "Toggle floating term" })

-- Initialize a flag to track the diagnostics state
local diagnostics_active = true

-- Define a function to toggle diagnostics
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

-- Map the function to <leader>tl in normal mode
vim.keymap.set(
  "n",
  "<leader>tl",
  toggle_diagnostics,
  { noremap = true, silent = true, desc = "Toggle LSP diagnostics" }
)
