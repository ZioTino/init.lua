-- Shows a lightbulb in the sign column when a code action is available.
return {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    config = function()
        require("nvim-lightbulb").setup({
            autocmd = {
                enabled = true,
                -- Keep the global updatetime from lua/tino/set.lua.
                updatetime = 100,
            },
        })
    end,
}
