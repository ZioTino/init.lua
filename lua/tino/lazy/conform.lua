-- Conform is a formatter manager: it runs format-on-save.
--
-- For C/C++ it runs the `clang-format` binary. clang-format discovers the
-- nearest `.clang-format` file by walking up the directory tree from the edited
-- file (`-style=file`, which is its default -- stated explicitly here), so
-- e.g. `ibcu/.clang-format` is applied to every file in that repository.
--
-- For every other filetype it falls back to the language server's own
-- formatting, preserving the previous LSP-based format-on-save behaviour.
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
            -- Format on save: clang-format for C/C++, LSP formatting otherwise.
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
            -- Don't notify when a buffer simply has no formatter available.
            notify_no_formatters = false,
        })
    end,
}