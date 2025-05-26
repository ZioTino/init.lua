return {
    "tpope/vim-fugitive",
    dependencies = {
        "lewis6991/gitsigns.nvim"
    },
    config = function()
        require("gitsigns").setup {
            signs                   = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signs_staged            = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signcolumn              = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl                   = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl                  = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff               = false, -- Toggle with `:Gitsigns toggle_word_diff`
            current_line_blame      = true,  -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
        }

        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })

        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        vim.keymap.set("n", "<leader>gm", "<cmd>Gvdiffsplit!<CR>")
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")

        vim.keymap.set("n", "<leader>ge", "<cmd>Gitsigns toggle_linehl<CR>")
    end
}
