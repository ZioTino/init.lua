return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup({
            ensure_installed = { "codelldb", "cpptools", },
        })
        require("mason-lspconfig").setup({
            automatic_enable = true,
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                -- "tsserver",
                "pylsp",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    -- Put format options here
                                    -- NOTE: the value should be STRING!!
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
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
                -- Prevent Mason to load up rust-analyzer
                ["rust_analyzer"] = function() end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

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
                source = false,
                header = "",
                prefix = '●', -- Or any character you prefer (e.g., '•', '❗')
            },
        })
    end
}
