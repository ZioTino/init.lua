local utils = require("tino.lsp.utils")

return {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    init = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                capabilities = utils.capabilities,
                on_attach = utils.on_attach,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                            extraArgs = { "--no-deps" }
                        },
                        checkOnSave = true,
                        diagnostics = {
                            styleLints = {
                                enable = true,
                            },
                        },
                    },
                },
            },
            -- DAP configuration
            dap = {},
        }
    end,
    lazy = false, -- This plugin is already lazy
}
