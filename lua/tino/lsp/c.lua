local utils = require("tino.lsp.utils")

-- clangd ships only the language server in the Mason/LLVM package, clang-tidy is
-- a separate executable. Passing --clang-tidy without it only produces warnings,
-- so enable it dynamically when the executable is reachable.
local clangd_args = { "--background-index" }
if utils.is_executable_installed("clang-tidy") then
    table.insert(clangd_args, "--clang-tidy")
end

vim.lsp.config.clangd = {
    cmd = vim.list_extend({ utils.get_executable_path("clangd") }, clangd_args),
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".clangd",
        "CMakeLists.txt",
        "Makefile",
        ".git",
    },
    capabilities = utils.capabilities,
    on_attach = utils.on_attach,
}
