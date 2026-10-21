local MIN_TREE_SITTER = { 0, 26, 1 }

-- The `main` branch compiles parsers with the tree-sitter CLI and needs
-- 0.26.1+, so an old CLI (e.g. the 0.20.x shipped by some distros) can't be
-- used even though `tree-sitter` is on PATH.
local function tree_sitter_version()
    if vim.fn.executable("tree-sitter") ~= 1 then
        return nil
    end

    local out = vim.fn.system({ "tree-sitter", "--version" })
    local version = out:match("(%d+%.%d+%.%d+)")
    return version and vim.version.parse(version) or nil
end

local function supports_tree_sitter(version)
    return version ~= nil and not vim.version.lt(version, MIN_TREE_SITTER)
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false, -- the main branch does not support lazy-loading
        build = function()
            -- Parsers can only be built with a recent enough tree-sitter CLI.
            if supports_tree_sitter(tree_sitter_version()) then
                vim.cmd("TSUpdate")
            end
        end,
        config = function()
            -- The main branch always compiles parsers with the `tree-sitter` CLI.
            -- Point it at gcc on Windows if no compiler has been selected.
            if vim.fn.has("win32") == 1 and vim.env.CC == nil and vim.fn.executable("gcc") == 1 then
                vim.env.CC = "gcc"
            end

            local nvim_treesitter = require("nvim-treesitter")

            -- The old `master` branch (now archived) does not have `install()`.
            -- Fail with an actionable message instead of a cryptic error popup.
            if type(nvim_treesitter.install) ~= "function" then
                vim.schedule(function()
                    vim.notify_once(
                        "nvim-treesitter is not on the 'main' branch (old API detected).\n"
                            .. "Run :Lazy update nvim-treesitter to switch branches.",
                        vim.log.levels.ERROR,
                        { title = "nvim-treesitter" }
                    )
                end)
                return
            end

            -- nvim-treesitter's `main` branch dropped support for Neovim 0.11.
            -- Failing here silently would look like broken highlighting, so be
            -- explicit about the version requirement.
            if vim.fn.has("nvim-0.12") == 0 then
                vim.schedule(function()
                    vim.notify_once(
                        "nvim-treesitter's 'main' branch requires Neovim 0.12 or newer.",
                        vim.log.levels.ERROR,
                        { title = "nvim-treesitter" }
                    )
                end)
                return
            end

            nvim_treesitter.setup()

            -- Parsers are compiled with the tree-sitter CLI; without a recent
            -- enough one every install attempt fails. Warn once instead of
            -- spamming errors.
            local ts_version = tree_sitter_version()
            local has_tree_sitter = supports_tree_sitter(ts_version)

            if has_tree_sitter then
                -- Installed asynchronously; already installed parsers are skipped.
                nvim_treesitter.install({
                    "c", "cpp", "lua", "vim", "vimdoc", "query",
                    "python", "rust", "markdown", "markdown_inline", "json",
                })
            else
                local found = ts_version
                        and string.format("%d.%d.%d", ts_version.major, ts_version.minor, ts_version.patch)
                    or "not found"
                -- Defer until startup is done so the warning is visible.
                vim.schedule(function()
                    vim.notify_once(
                        "tree-sitter CLI " .. found .. " is unusable; 0.26.1 or newer is required.\n"
                            .. "  Windows: winget install tree-sitter.tree-sitter-cli\n"
                            .. "  Linux/macOS: install tree-sitter-cli 0.26.1+\n"
                            .. "Also install a C compiler (gcc/clang), then restart Neovim.",
                        vim.log.levels.WARN,
                        { title = "nvim-treesitter" }
                    )
                end)
            end

            -- The main branch only ships queries: highlighting, indentation and
            -- injections have to be enabled per buffer.
            local available_parsers
            local requested_parsers = {}

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TinoTreesitter", { clear = true }),
                callback = function(args)
                    local buf = args.buf
                    local filetype = vim.bo[buf].filetype
                    local lang = vim.treesitter.language.get_lang(filetype) or filetype

                    local max_filesize = 200 * 1024 -- 200 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify(
                            "File larger than 200KB: treesitter disabled for performance.",
                            vim.log.levels.WARN,
                            { title = "Treesitter" }
                        )
                        return
                    end

                    -- No parser installed for this filetype.
                    if not pcall(vim.treesitter.start, buf, lang) then
                        -- Install it on demand, like the old `auto_install` did
                        -- (only when the tree-sitter toolchain is available).
                        if has_tree_sitter then
                            available_parsers = available_parsers
                                or require("nvim-treesitter.config").get_available()
                            if not requested_parsers[lang] and vim.tbl_contains(available_parsers, lang) then
                                requested_parsers[lang] = true
                                require("nvim-treesitter").install({ lang })
                            end
                        end
                        return
                    end

                    -- Keep regex syntax alongside treesitter for markdown.
                    if filetype == "markdown" then
                        vim.bo[buf].syntax = "ON"
                    end

                    if vim.treesitter.query.get(lang, "indents") then
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require 'treesitter-context'.setup {
                enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                multiwindow = false,      -- Enable multiwindow support.
                max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20,     -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end
    }
}
