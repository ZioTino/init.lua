-- Jupyter notebooks in native buffers. Requires jupytext and a Python with
-- jupyter_client + ipykernel (see README.md). Do not install jupytext.nvim:
-- it registers the same BufReadCmd for *.ipynb and jove refuses to load.
return {
    "nghiant03/jove.nvim",
    -- Follow the latest stable tag. lazy.nvim's version ranges are semver and
    -- do not accept the upstream's "v*" form.
    version = "*",
    lazy = false,
    opts = {
        auto_kernel = true,
    },
    config = function(_, opts)
        require("jove").setup(opts)

        -- Bind jove's buffer-local <Plug> mappings only in notebooks, so these
        -- keys keep their normal meaning everywhere else.
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("TinoJove", { clear = true }),
            pattern = "*.ipynb",
            callback = function(args)
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "Jove: " .. desc })
                end

                map("n", "<leader>x", "<Plug>(JoveRunCell)", "Run cell")
                map("n", "<leader>X", "<Plug>(JoveRunCellAndAdvance)", "Run cell and advance")
                map("x", "<leader>xx", "<Plug>(JoveRunSelection)", "Run selection")
                map("n", "<leader>c", "<Plug>(JoveNewCell)", "New cell below")
                map("n", "<leader>j", "<Plug>(JoveGotoRunningCell)", "Go to running cell")
                map("n", "<leader>J", "<Plug>(JoveToggleFollowRunning)", "Toggle follow running cell")
            end,
        })
    end,
}
