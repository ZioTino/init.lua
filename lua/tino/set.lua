local user_home

-- Check if the OS is Windows
-- Lua's os.getenv returns nil if the variable doesn't exist.
-- On Windows, 'HOMEPATH' and 'HOMEDRIVE' are typically used together for the home directory.
-- %USERPROFILE% is a more direct equivalent to HOME on Windows.
if os.getenv('OS') == 'Windows_NT' then
    user_home = os.getenv('USERPROFILE')
else
    user_home = os.getenv('HOME')
end

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

if user_home then
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undodir = user_home .. "/.vim/undodir"
    vim.opt.undofile = true
end

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Set clipboard
vim.api.nvim_set_option_value("clipboard", "unnamedplus", {})

-- Hide blank lines (or end of file lines, '~')
vim.api.nvim_set_option_value("fillchars", "eob: ", {})
