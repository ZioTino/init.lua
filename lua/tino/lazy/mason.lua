return {
    "mason-org/mason.nvim",
    config = function()
        require("mason").setup({
            ensure_installed = {
                "codelldb",
                "cpptools",
                "python-lsp-server",
                "debugpy",
                "lua-language-server",
                "json-lsp"
            },
        })
    end,
}
