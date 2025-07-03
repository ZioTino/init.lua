vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
    local buffer = args.buf

    local wid = nil
    local win_ids = vim.api.nvim_list_wins() -- Get all window IDs
    for _, win_id in ipairs(win_ids) do
        local win_bufnr = vim.api.nvim_win_get_buf(win_id)
        if win_bufnr == buffer then
            wid = win_id
        end
    end

    if wid == nil then
        return
    end

    vim.schedule(function()
        if vim.api.nvim_win_is_valid(wid) then
            vim.api.nvim_set_current_win(wid)
        end
    end)
end

local function create_nav_options(name)
    return {
        group = "DapGroup",
        pattern = string.format("*%s*", name),
        callback = navigate
    }
end

return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        config = function()
            local dap = require("dap")
            dap.set_log_level("DEBUG")

            vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition",
                { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "", texthl = "Search", linehl = "Search", numhl = "Search" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })

            require("overseer").enable_dap()
            require("dap.ext.vscode").load_launchjs()
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "mfussenegger/nvim-dap-python",
            "stevearc/overseer.nvim",
            "akinsho/toggleterm.nvim",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DapGroup",
                pattern = "*dap-repl*",
                callback = function()
                    vim.wo.wrap = true
                end,
            })

            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))

            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

            dapui.setup({
                layouts = {
                    elements = {
                        { id = "scopes",      size = 0.50 },
                        { id = "breakpoints", size = 0.20 },
                        { id = "stacks",      size = 0.15 },
                        { id = "watches",     size = 0.15 },
                    },
                    position = "right",
                    size = 40,
                    enter = true,
                },
                enter = true,
            })

            vim.keymap.set("n", "<leader>dt", function()
                    dapui.toggle()
                end,
                { desc = "Debug: toggle ui" })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            dap.listeners.after.event_output.dapui_config = function(_, body)
                if body.category == "console" then
                    dapui.eval(body.output) -- Sends console (error?) to Tooltip
                end
            end

            dap.listeners.on_config["dummy-noop"] = function(config)
                local final = vim.deepcopy(config)
                final.console = "integratedTerminal"
                final.justMyCode = false
                final.redirectOutput = true
                final.stopOnEntry = true
                return final
            end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "python",
                },
                automatic_installation = true,
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })
            require("dap").adapters.python = function(cb, config)
                if config.request == "attach" then
                    local port = (config.connect or config).port
                    local host = (config.connect or config).host or '127.0.0.1'
                    cb {
                        type = "server",
                        port = assert(
                            port,
                            '`connect.port` is required for a python `attach` configuration'
                        ),
                        host = host,
                        options = {
                            source_filetype = 'python',
                        },
                    }
                else
                    local venv_path = os.getenv("VIRTUAL_ENV")
                    local py_path = nil
                    if venv_path ~= nil then
                        py_path = venv_path .. "/bin/python3"
                    else
                        py_path = vim.g.python3_host_prog
                    end
                    cb {
                        type = "executable",
                        command = py_path,
                        args = { "-m", "debugpy.adapter" },
                        options = {
                            source_filetype = "python",
                        },
                    }
                end
            end
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        lazy = true,
        config = function()
            local dap_python = require("dap-python")
            local python = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            dap_python.setup(python, {
                include_configs = true,
                console = "integratedTerminal",
                pythonPath = nil,
            })
        end,
        dependencies = {
            "mfussenegger/nvim-dap",
            "jay-babu/mason-nvim-dap.nvim",
        },
    }
}
