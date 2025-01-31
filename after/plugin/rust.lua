vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
        -- hover_actions = {
        --     -- Do not replace builtin `vim.lsp.buf.hover`
        --     replace_builtin_hover = false,
        -- }
    },
    -- LSP configuration
    server = {
        on_attach = function(client, bufnr)
        end,
        -- default_settings = {
        --     -- rust-analyzer language server configuration
        --     ['rust-analyzer'] = {
        --         server = {
        --             extraEnv = {
        --                 CARGO_TARGET_DIR = "target/rust-analyzer",
        --             }
        --         },
        --         check = {
        --             extraArgs = { "--target-dir=target/rust-analyzer" },
        --         }
        --     }
        -- }
    },
    -- DAP configuration
    dap = {},
}
