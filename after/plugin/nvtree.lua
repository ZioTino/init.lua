local function custom_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    -- Custom mappings
    -- vim.keymap.set("n", "<leader>b", "<Cmd>:NvimTreeToggle<CR>", { silent = true})
    vim.keymap.set("n", "<leader>n", "<Cmd>:NvimTreeFocus<CR>", { silent = true })
end

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
    }
}
