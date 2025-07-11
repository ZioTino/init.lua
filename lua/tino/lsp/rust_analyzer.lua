local on_attach = require("tino.lsp.utils").on_attach

vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        on_attach = on_attach,
        default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
            },
        },
    },
    -- DAP configuration
    dap = {
    },
}
