require("tino.lsp.lua")
require("tino.lsp.python")
require("tino.lsp.json")

-- Configure diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = '●', -- Or any character you prefer (e.g., '•', '❗')
        source = false, -- Show the source of the diagnostic (e.g., 'eslint', 'tsserver')
        severity_sort = true, -- Sort diagnostics by severity
    },
    signs = true, -- Show signs in the sign column (recommended alongside virtual text)
    underline = true, -- Underline the problematic text
    update_in_insert = false, -- Don't update diagnostics in insert mode (can be noisy)
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = '● ', -- Or any character you prefer (e.g., '•', '❗')
    },
})

-- Enable LSP configured servers
vim.lsp.enable({
    "lua_ls",  -- lua
    "pylsp",   -- python
    -- "rust_analyzer", -- We don't need to enable it here since rustaceanvim takes care of everything
    "json_ls", -- json
})
