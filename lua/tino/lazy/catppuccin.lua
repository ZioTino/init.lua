return {
    "catppuccin/nvim",
    prority = 1000,
    config = function()
        require("catppuccin").setup({
            auto_integrations = true, -- Let catppuccin automatically detect installed plugins and enable their respective integrations
            flavour = "mocha",
            transparent_background = true,
            term_colors = false,
            dim_inactive = {
                enabled = false,
            },
            float = {
                -- Let the terminal background image show through floats.
                -- The hover border keeps it readable (see lua/tino/init.lua).
                transparent = true,
            },
            show_end_of_buffer = true,
            lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                    ok = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            highlight_overrides = {
                all = function(colors)
                    return {
                        LineNr = { fg = "#A0A0A0" },

                        -- Thin neutral border line; no background fill, so
                        -- floating views keep their own layout and transparency.
                        FloatBorder = { fg = "#9a9a9a", bg = "NONE" },
                    }
                end
            }
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
