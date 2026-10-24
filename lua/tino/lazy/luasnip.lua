-- LuaSnip is the snippet engine used by nvim-cmp (via cmp_luasnip) and by
-- nvim's built-in LSP snippets.
return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    config = function()
        local ls = require("luasnip")

        ls.setup({
            -- Allow jumping back into snippets that were left with jump(-1).
            history = true,
            -- Re-evaluate dynamic nodes while the snippet is being edited.
            updateevents = "TextChanged,TextChangedI",
        })

        -- Load VS Code-style snippet collections found on the runtimepath
        -- (e.g. friendly-snippets). No-op when none are installed.
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Expand a snippet or jump to its next tabstop; leave a regular tab
        -- alone when there is nothing to expand.
        vim.keymap.set({ "i", "s" }, "<Tab>", function()
            if ls.expand_or_jumpable() then
                return "<Plug>luasnip-expand-or-jump"
            end
            return "<Tab>"
        end, { silent = true, expr = true, desc = "LuaSnip: expand or jump" })

        -- Jump back to the previous tabstop; keep the native Shift-Tab when
        -- there is no snippet to return to.
        vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
            if ls.jumpable(-1) then
                return "<Plug>luasnip-jump-prev"
            end
            return "<S-Tab>"
        end, { silent = true, expr = true, desc = "LuaSnip: jump back" })

        -- Cycle through choice nodes; keep the native Ctrl-E otherwise.
        vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then
                return "<Plug>luasnip-next-choice"
            end
            return "<C-E>"
        end, { silent = true, expr = true, desc = "LuaSnip: next choice" })
    end,
}
