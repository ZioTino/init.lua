local utils = require("tino.lsp.utils")

vim.lsp.config.pylsp = {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    capabilities = utils.capabilities,
    on_attach = utils.on_attach,
    settings = {
        pylsp = {
            configurationSources = { "flake8", "pycodestyle", "pylint" }, -- Order of precedence
            plugins = {
                autopep8 = { enabled = true, },                           -- Disabling requires to use `yapf`
                flake8 = {
                    enabled = utils.python.is_executable_installed("flake8"),
                    executable = utils.python.get_executable_path("flake8"),
                },
                mccabe = {
                    enabled = true,
                    threshold = 15, -- The minimum threshold that triggers warnings about cyclomatic complexity.
                },
                pycodestyle = {
                    enabled = utils.python.is_executable_installed("pycodestyle"),
                    maxLineLength = 100 -- Never above 100.
                },
                pydocstyle = { enabled = true, },
                pyflakes = { enabled = true, },
                pylint = {
                    enabled = utils.python.is_executable_installed("pylint"),
                    executable = utils.python.get_executable_path("pylint"),
                },
                rope_autoimport = { enabled = false, },
                rope_completion = { enabled = true, },
                yapf = { enabled = false },

                -- Below plugins are not present anymore in python-lsp-server documentation
                -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
                --
                -- black = { enabled = false }, --
                -- ruff = { enabled = false },
                -- pylsp_mypy = {
                --     enabled = true,
                --     overrides = { "--python-executable", py_path, true },
                --     report_progress = true,
                --     live_mode = false,
                -- }
            },
            rope = {
                extensionModules = nil,
                ropeFolder = nil,
            },
            signature = {
                formatter = "black",
                line_length = 88,
            },
        },
    },
}
