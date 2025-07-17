local utils = require("tino.lsp.utils")

-- Get venv path if applicable instead of global python path
-- Since we use pyenv python versions might be different
local venv_path = os.getenv("VIRTUAL_ENV")
local py_path = nil
if venv_path ~= nil then
    py_path = venv_path .. "/bin/python3"
else
    py_path = vim.g.python3_host_prog
end

-- Mason default location
local mason_path = vim.fn.stdpath("data") .. "/mason"

-- Function to get executable path based on priorities:
-- First checks if is installed in venv
-- Then it checks if is installed in Mason
-- Else it fallbacks to the default location if any.
local get_executable_path = function(executable)
    local path = "/bin/" .. executable
    if venv_path ~= nil then
        return venv_path .. path
    elseif mason_path ~= nil then
        return mason_path .. path
    end
    return executable
end

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
                    enabled = true,
                    executable = get_executable_path("flake8"),
                },
                mccabe = {
                    enabled = true,
                    threshold = 15, -- The minimum threshold that triggers warnings about cyclomatic complexity.
                },
                pycodestyle = { enabled = true, },
                pydocstyle = { enabled = true, },
                pyflakes = { enabled = true, },
                pylint = {
                    enabled = false,
                    executable = get_executable_path("pylint"),
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
