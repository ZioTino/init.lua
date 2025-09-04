local cmp_lsp = require("cmp_nvim_lsp")

-- On attach for auto formatting on save
local on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "Tino",
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end
    })
end

-- Create capabilities
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

-- Check if a file or directory exists in this path
local exists = function(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

-- Same as exists() but for directories
local is_directory = function(path)
    -- "/" works on both Unix and Windows
    return exists(path .. "/")
end

-- Get venv path if applicable instead of global python path
-- Since we use pyenv python versions might be different
local venv_path = os.getenv("VIRTUAL_ENV")
local py_path = nil
if venv_path ~= nil then
    if os.getenv("OS") == "Windows_NT" then
        py_path = venv_path .. "\\Scripts\\python.exe"
    else
        py_path = venv_path .. "/bin/python3"
    end
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
    local path = nil
    if os.getenv("OS") == "Windows_NT" then
        path = "\\Scripts\\" .. executable .. ".exe"
    else
        path = "/bin/" .. executable
    end
    if venv_path ~= nil then
        return venv_path .. path
    elseif is_directory(mason_path) and exists(mason_path .. path) ~= nil then
        return mason_path .. path
    end
    return executable
end

--- Function to check if executable is present or not
--- It looks in installed venv if present
--- Then it looks in Mason path
--- Else it looks in default bin path, so if executable is installed globally it returns true.
local is_executable_installed = function(executable)
    return exists(get_executable_path(executable)) ~= nil
end

return {
    capabilities = capabilities,
    on_attach = on_attach,
    exists = exists,
    is_directory = is_directory,
    mason_path = mason_path,
    python = {
        path = py_path,
        venv_path = venv_path,
        get_executable_path = get_executable_path,
        is_executable_installed = is_executable_installed,
    }
}
