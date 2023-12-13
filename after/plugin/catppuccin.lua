require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    term_colors = false,
    dim_inactive = {
        enabled = false,
    },
})

vim.cmd.colorscheme "catppuccin"
