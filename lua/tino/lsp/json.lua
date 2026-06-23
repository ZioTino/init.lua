local utils = require("tino.lsp.utils")

vim.lsp.config.json_ls = {
    cmd = { utils.get_executable_path("vscode-json-language-server"), "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    capabilities = utils.capabilities,
    on_attach = utils.on_attach,
    init_options = {
        provideFormatter = true,
    },
    settings = {},
}
