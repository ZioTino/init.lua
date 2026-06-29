local user_home

-- Check if the OS is Windows
-- Lua's os.getenv returns nil if the variable doesn't exist.
-- On Windows, 'HOMEPATH' and 'HOMEDRIVE' are typically used together for the home directory.
-- %USERPROFILE% is a more direct equivalent to HOME on Windows.
if os.getenv('OS') == 'Windows_NT' then
    local progfiles = vim.fn.expand("$PROGRAMFILES"):gsub('\\', '/')
    local git_bash = '"' .. progfiles .. '/Git/bin/bash.exe"'
    user_home = os.getenv('USERPROFILE')
    if vim.fn.executable(progfiles .. '/Git/bin/bash.exe') == 1 then
        vim.opt.shell = git_bash
        vim.opt.shellcmdflag = '-c'
        vim.opt.shellquote = ''
        vim.opt.shellxquote = ''
    end
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

vim.opt.updatetime = 100

-- Set clipboard
-- vim.api.nvim_set_option_value("clipboard", "unnamedplus", {})
vim.o.clipboard = "unnamedplus"
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = function()
            if os.getenv('OS') == 'Windows_NT' then
                local out = vim.fn.system('powershell.exe -NoProfile -command "Get-Clipboard"')
                out = out:gsub('\r\n', '\n'):gsub('\r', '\n')
                out = out:gsub('\n$', '') -- Strip only the trailing newline added by Get-Clipboard
                return vim.split(out, '\n')
            else
                return require("vim.ui.clipboard.osc52").paste("+")
            end
        end,
        ["*"] = function()
            if os.getenv('OS') == 'Windows_NT' then
                local out = vim.fn.system('powershell.exe -NoProfile -command "Get-Clipboard"')
                out = out:gsub('\r\n', '\n'):gsub('\r', '\n')
                out = out:gsub('\n$', '') -- Strip only the trailing newline added by Get-Clipboard
                return vim.split(out, '\n')
            else
                return require("vim.ui.clipboard.osc52").paste("*")
            end
        end,

    },
}

-- Hide blank lines (or end of file lines, '~')
vim.api.nvim_set_option_value("fillchars", "eob: ", {})
