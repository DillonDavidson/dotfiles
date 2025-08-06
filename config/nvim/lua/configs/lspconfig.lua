require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "clangd", "gopls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
