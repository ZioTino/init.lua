return {
    "DrKJeff16/boolean-toggle.nvim",
    config = function()
        require("boolean-toggle").setup({
            -- Toggling a value shouldn't write the buffer; saving stays explicit.
            auto_write = false,
        })

        vim.keymap.set("n", "<leader>tb", function()
            require("boolean-toggle").cursor_toggle_boolean()
        end, { desc = "Toggle boolean under cursor" })
    end,
}
