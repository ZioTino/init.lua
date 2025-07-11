-- Fidget is the notification manager in the bottom right
return {
    "j-hui/fidget.nvim",
    config = function()
        require("fidget").setup({
            integration = {
                ["nvim-tree"] = {
                    enable = true,
                }
            }
        })
    end,
}
