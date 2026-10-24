-- nvim-ufo replaces the default fold providers with LSP/treesitter ranges and
-- keeps folds fast. The treesitter provider uses the `folds.scm` queries that
-- nvim-treesitter installs, with indentation as a fallback.
return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    config = function()
        vim.opt.foldcolumn = "1"
        vim.opt.foldlevel = 99 -- ufo needs a large foldlevel to control folds itself
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true
        vim.opt.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"

        require("ufo").setup({
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        })

        -- ufo manages foldlevel itself, so the built-in zR/zM/zr/zm have to be
        -- replaced by the API that keeps foldlevel untouched.
        vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Folds: open all" })
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Folds: close all" })
        vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Folds: open except kinds" })
        vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Folds: close with level" })
    end,
}
