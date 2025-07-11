-- On attach for auto formatting on save
local on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = "LspFormatting",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = true })
            end
        })
    end
end

return {
    on_attach = on_attach,
}
