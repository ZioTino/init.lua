return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-media-files.nvim" },
    },
    config = function()
        -- Fix for "Invalid window id: 1000 error"
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/7952
        local actions = require("telescope.actions")
        local open_after_tree = function(prompt_bufnr)
            vim.defer_fn(function()
                actions.select_default(prompt_bufnr)
            end, 100) -- Delay allows filetype and plugins to settle before opening
        end

        require("telescope").setup({
            defaults = {
                mappings = {
                    i = { ["<CR>"] = open_after_tree },
                    n = { ["<CR>"] = open_after_tree },
                },
            },
            extensions = {
                media_files = {
                    -- filetypes whitelist
                    -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    -- find command (defaults to `fd`)
                    find_cmd = "rg"
                }
            }
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>m', function()
            builtin.resume()
        end)
    end
}
