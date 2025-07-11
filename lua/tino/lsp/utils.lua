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

return {
    capabilities = capabilities,
    on_attach = on_attach,
}
