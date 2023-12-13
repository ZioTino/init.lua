require("toggleterm").setup{
    size = function(term)
        if term.direction == "horizontal" then
            return 25
        elseif term.direction == "vertical" then
            return 50
        end
    end,
    hide_numbers = true,
    shade_terminal = false,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = false,
    close_on_exit = false,
    auto_scroll = true,
    direction = 'float',
}

vim.keymap.set("n", "<leader>t", "<Cmd>ToggleTerm<CR>", { silent = true })
