require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "clangd", "gopls", "jdtls", "rust_analyzer", "csharp_ls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
