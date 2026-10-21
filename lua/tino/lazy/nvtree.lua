local function custom_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
end

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup {
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true,
            on_attach = custom_attach,
            view = {
                width = 45,
                float = {
                    quit_on_focus_loss = true,
                }
            },
            filters = {
                git_ignored = false,
                dotfiles = false
            },
            git = {
                enable = true,
                -- nvim-tree kills `git status` after this many ms and disables
                -- git integration for the session after 5 timeouts.
                -- The 400ms default is too aggressive for large repositories.
                timeout = 5000,
            },
        }

        vim.keymap.set("n", "<leader>n", "<Cmd>:NvimTreeFocus<CR>", { silent = true })
    end
}
