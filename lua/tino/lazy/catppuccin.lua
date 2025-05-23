return {
    "catppuccin/nvim",
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            term_colors = false,
            dim_inactive = {
                enabled = false,
            },
            integrations = {
                nvimtree = true,
                treesitter = true,
            },
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
