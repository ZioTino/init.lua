-- Fidget is the notification manager in the bottom right
return {
    "j-hui/fidget.nvim",
    dependencies = {
        "nvim-tree/nvim-tree.lua",
    },
    config = function()
        require("fidget").setup({
            integration = {
                ["nvim-tree"] = {
                    enable = false,
                }
            }
        })
    end,
}
