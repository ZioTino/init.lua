local utils = require("tino.lsp.utils")

vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    capabilities = utils.capabilities,
    on_attach = utils.on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Include Neovim runtime files
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Recognize `vim` as a global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            hint = {
                enable = true,
                arrayIndex = "Enable",
                await = true,
                paramName = "All",
                paramType = true,
                semicolon = "Disable",
                setType = true,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                }
            }
        },
    },
}
