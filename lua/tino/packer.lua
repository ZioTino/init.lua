-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use({
        "catppuccin/nvim",
        as = "catppuccin",
    })

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-media-files.nvim' },
        }
    }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('theprimeagen/harpoon')

    use('mbbill/undotree')

    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }

    use {
        "akinsho/toggleterm.nvim",
        tag = '*',
        config = function()
            require("toggleterm").setup()
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
        'iamcco/markdown-preview.nvim',
        run = function()
            vim.fn["mkdp#util#install"]()
        end
    }

    use 'sindrets/diffview.nvim'

    use 'stevearc/dressing.nvim'

    use {
        'stevearc/overseer.nvim',
        config = function() require('overseer').setup() end
    }

    use 'mfussenegger/nvim-dap'

    use 'mrcjkb/rustaceanvim'

    use {
        'rcarriga/nvim-dap-ui',
        requires = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    }

    use {
        'folke/lazydev.nvim',
        config = function()
            require('lazydev').setup({
                library = { 'nvim-dap-ui' },
            })
        end
    }
end)
