return {
    "stevearc/overseer.nvim",
    config = function()
        require("overseer").setup({
            dap = true, -- Patch nvim-dap to support preLaunchTask and postDebugTask
            output = {
                use_terminal = false,
                preserve_output = true,
            },
            task_list = {
                direction = "bottom",
                -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_width and max_width can be a single value or a list of mixed integer/float types.
                -- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
                max_width = { 100, 0.2 },
                -- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
                min_width = { 40, 0.1 },
                max_height = { 20, 0.2 },
                min_height = 8,
                render = function(task)
                    return require("overseer.render").format_standard(task)
                end,
                sort = function(a, b)
                    return require("overseer.task_list").default_sort(a, b)
                end,
                keymaps = {
                    ["["] = "DecreaseHeight",
                    ["]"] = "IncreaseHeight",
                    ["?"] = "keymap.show_help",
                    ["g?"] = "keymap.show_help",
                    ["<CR>"] = "keymap.run_action",
                    ["dd"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Dispose task" },
                    ["<C-e>"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
                    ["o"] = "keymap.open",
                    ["<C-v>"] = { "keymap.open", opts = { dir = "vsplit" }, desc = "Open task output in vsplit" },
                    ["<C-s>"] = { "keymap.open", opts = { dir = "split" }, desc = "Open task output in split" },
                    ["<C-t>"] = { "keymap.open", opts = { dir = "tab" }, desc = "Open task output in tab" },
                    ["<C-f>"] = { "keymap.open", opts = { dir = "float" }, desc = "Open task output in float" },
                    ["<C-q>"] = {
                        "keymap.run_action",
                        opts = { action = "open output in quickfix" },
                        desc = "Open task output in the quickfix",
                    },
                    ["p"] = "keymap.toggle_preview",
                    ["{"] = "keymap.prev_task",
                    ["}"] = "keymap.next_task",
                    ["<C-k>"] = "keymap.scroll_output_up",
                    ["<C-j>"] = "keymap.scroll_output_down",
                    ["g."] = "keymap.toggle_show_wrapped",
                    ["q"] = { "<CMD>close<CR>", desc = "Close task list" },
                },
            },
            form = {
                zindex = 40,
                -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                -- min_X and max_X can be a single value or a list of mixed integer/float types.
                min_width = 80,
                max_width = 0.9,
                min_height = 10,
                max_height = 0.9,
                -- border = nil,
                -- Set any window options here (e.g. winhighlight)
                win_opts = {},
            },
            -- Configuration for task floating output windows
            task_win = {
                padding = 2,
                -- border = nil,
                win_opts = {},
            },
            -- Aliases for bundles of components. Redefine the builtins, or create your own.
            component_aliases = {
                -- Most tasks are initialized with the default components
                default = {
                    "on_exit_set_status",
                    "on_complete_notify",
                    { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
                },
                -- Tasks from tasks.json use these components
                default_vscode = {
                    "default",
                    "on_result_diagnostics",
                },
                -- Tasks created from experimental_wrap_builtins
                default_builtin = {
                    "on_exit_set_status",
                    "on_complete_dispose",
                    { "unique", soft = true },
                },
            },
        })
    end
}
