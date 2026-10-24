-- Smooth cursor/scroll animations. See lua/tino/remap.lua for the n/N
-- centering mappings that are restored after whisk installs its own.
return {
    "josstei/whisk.nvim",
    event = "VeryLazy",
    init = function()
        -- Let lazy.nvim call setup() exactly once (via the config below).
        vim.g.whisk_auto_setup = 0
    end,
    opts = {
        cursor = { duration = 150, easing = "ease-out" },
        scroll = { duration = 200, easing = "ease-in-out" },
    },
    config = function(_, opts)
        require("whisk").setup(opts)

        -- whisk animates n/N too; restoring these keeps search centered.
        vim.keymap.set("n", "n", "nzzzv")
        vim.keymap.set("n", "N", "Nzzzv")
    end,
}
