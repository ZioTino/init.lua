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

-- OSC 52 is only usable in terminals that implement it. Some terminals (e.g.
-- cosmic-term, the default on Pop!_OS/COSMIC) explicitly deny it, so prefer a
-- native clipboard tool and only fall back to OSC 52 when none is available.
local function executable(name)
    return vim.fn.executable(name) == 1
end

if os.getenv('OS') == 'Windows_NT' then
    -- win32yank.exe ships next to nvim.exe in the Neovim Windows zip. It is a
    -- tiny native binary, so copy/paste don't need to spawn PowerShell.
    local win32yank = vim.fn.exepath('win32yank.exe')
    if win32yank == '' then
        local bundled = vim.fs.joinpath(vim.fn.fnamemodify(vim.v.progpath, ':h'), 'win32yank.exe')
        if vim.fn.filereadable(bundled) == 1 then
            win32yank = bundled
        end
    end

    if win32yank ~= '' then
        vim.g.clipboard = {
            name = 'win32yank',
            copy = {
                ['+'] = { win32yank, '-i', '--crlf' },
                ['*'] = { win32yank, '-i', '--crlf' },
            },
            paste = {
                ['+'] = { win32yank, '-o', '--lf' },
                ['*'] = { win32yank, '-o', '--lf' },
            },
            cache_enabled = 1,
        }
    else
        -- Fallback: OSC 52 for copy (fast, Windows Terminal supports it) and
        -- PowerShell for paste. PowerShell startup is the slow part, hence the
        -- -NoProfile/-NonInteractive flags.
        local function windows_paste()
            local out = vim.fn.system({
                'powershell.exe', '-NoProfile', '-NoLogo', '-NonInteractive',
                '-Command', 'Get-Clipboard -Raw',
            })
            out = out:gsub('\r\n', '\n'):gsub('\r', '\n')
            out = out:gsub('\n$', '') -- Strip only the trailing newline added by Get-Clipboard
            return vim.split(out, '\n')
        end

        vim.g.clipboard = {
            name = "OSC 52",
            copy = {
                ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
                ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
            },
            paste = {
                ["+"] = windows_paste,
                ["*"] = windows_paste,
            },
        }
    end
elseif os.getenv('WAYLAND_DISPLAY') and executable('wl-copy') and executable('wl-paste') then
    -- Native Wayland clipboard (package: wl-clipboard)
    vim.g.clipboard = "wl-copy"
elseif os.getenv('DISPLAY') and executable('xsel') then
    -- X11/XWayland clipboard
    vim.g.clipboard = "xsel"
elseif os.getenv('DISPLAY') and executable('xclip') then
    vim.g.clipboard = "xclip"
else
    vim.g.clipboard = "osc52"
end

-- Hide blank lines (or end of file lines, '~')
vim.api.nvim_set_option_value("fillchars", "eob: ", {})
