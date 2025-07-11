require("tino.remap")
require("tino.set")
require("tino.lazy_init")
require("tino.lsp")

local augroup = vim.api.nvim_create_augroup
local TinoGroup = augroup("Tino", {})

local autocmd = vim.api.nvim_create_autocmd

-- Override line number color
-- The one from catppuccin does not work well with my background
autocmd({ "BufEnter", "BufWinEnter" }, {
    group = TinoGroup,
    command = "highlight LineNr guifg=#A0A0A0"
})

autocmd("LspAttach", {
    group = TinoGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})
