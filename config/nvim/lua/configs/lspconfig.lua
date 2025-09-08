require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "clangd", "gopls", "rust_analyzer", "jdtls", "zls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
