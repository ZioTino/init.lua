-- Conform is a formatter manager. Formatting is manual: <leader>fm formats the
-- current buffer (or the visual selection); there is no format-on-save.
--
-- For C/C++ it runs the `clang-format` binary. clang-format discovers the
-- nearest `.clang-format` file by walking up the directory tree from the edited
-- file (`-style=file`, which is its default -- stated explicitly here), so
-- e.g. `ibcu/.clang-format` is applied to every file in that repository.
--
-- For every other filetype it falls back to the language server's own
-- formatting.
return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            formatters = {
                ["clang-format"] = {
                    -- `file` = read the project's `.clang-format`.
                    prepend_args = { "-style=file" },
                },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- Don't notify when a buffer simply has no formatter available.
            notify_no_formatters = false,
        })

        -- Format the current buffer, or the selected range in visual mode.
        vim.keymap.set({ "n", "v" }, "<leader>fm", function()
            require("conform").format({
                async = true,
                lsp_format = "fallback",
            })
        end, { desc = "Format buffer/selection" })
    end,
}
