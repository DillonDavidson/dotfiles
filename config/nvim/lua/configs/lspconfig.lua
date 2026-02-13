require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "clangd", "gopls", "hls" } -- "zls", "rust_analyzer"
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
