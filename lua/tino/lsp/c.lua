local utils = require("tino.lsp.utils")

vim.lsp.config.clangd = {
    cmd = { utils.get_executable_path("clangd"), "--background-index", "--clang-tidy" },
    filetypes = { "c", "objc" },
    root_markers = { "compile_commands.json", "Makefile", ".git" },
    capabilities = utils.capabilities,
    on_attach = utils.on_attach,
}
