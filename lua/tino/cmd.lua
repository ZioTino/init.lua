vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
vim.cmd [[autocmd BufWinEnter * highlight LineNr guifg=#A0A0A0]]
