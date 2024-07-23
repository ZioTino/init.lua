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
    color_overrides = {
        mocha = {
            surface1 = "#A0A0A0",
            surface0 = "#707070",
        },
    },
})

vim.cmd.colorscheme "catppuccin"
