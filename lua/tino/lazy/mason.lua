return {
    "mason-org/mason.nvim",
    config = function()
        require("mason").setup({
            ensure_installed = {
                "codelldb",
                "cpptools",
                "rust-analyzer",
                "python-lsp-server",
                "debugpy",
                "lua-language-server",
            },
        })
    end,
}
