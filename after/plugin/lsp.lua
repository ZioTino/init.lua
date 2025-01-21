local lsp_zero = require('lsp-zero')

lsp_zero.preset("recommended")

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

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
end)

local lspconfig = require('lspconfig')

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "pylsp", "rust_analyzer" },
})
require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name)  -- default handler (optional)
        lspconfig[server_name].setup {}
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    --["rust_analyzer"] = function ()
    --    require("rust-tools").setup {}
    --end
    ["pylsp"] = function()
        local venv_path = os.getenv("VIRTUAL_ENV")
        local py_path = nil
        if venv_path ~= nil then
            py_path = venv_path .. "/bin/python3"
        else
            py_path = vim.g.python3_host_prog
        end
        lspconfig.pylsp.setup {
            settings = {
                pylsp = {
                    plugins = {
                        -- formatter options
                        black = { enabled = true },
                        autopep8 = { enabled = false },
                        yapf = { enabled = false },
                        -- linter options
                        pylint = { enabled = true, executable = "pylint" },
                        ruff = { enabled = false },
                        pyflakes = { enabled = false },
                        pycodestyle = { enabled = false },
                        -- type checker
                        pylsp_mypy = {
                            enabled = true,
                            overrides = { "--python-executable", py_path, true },
                            report_progress = true,
                            live_mode = false
                        }
                    }
                }
            },
            flags = {
                debounce_text_changes = 200
            }
        }
    end,
    ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup {}
    end,
}


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lua' },
    },
    -- formatting = lsp_zero.cmp_format(),
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
