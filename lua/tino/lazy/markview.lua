return {
    "OXY2DEV/markview.nvim",
    -- Markview lazy-loads itself per filetype. Deferring it through lazy.nvim
    -- only makes the first preview slower, so load it at startup instead.
    lazy = false,

    -- Preview is on by default; `:Markview` toggles it, `:Markview splitToggle`
    -- opens a side-by-side preview.
}
