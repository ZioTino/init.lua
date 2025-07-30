return {
    "stevearc/overseer.nvim",
    config = function()
        require("overseer").setup({
            max_height = { 40, 0.2 },
            min_height = 16,
            bindings = {
                ["["] = "DecreaseHeight",
                ["]"] = "IncreaseHeight",
            },
            strategy = {
                "toggleterm",
                use_shell = true,
                direction = "float",
                auto_scroll = true,
                close_on_exit = true,
                quit_on_exit = "success",
                open_on_start = true,
                hidden = false,
                on_create = nil,
            },
        })
    end
}
