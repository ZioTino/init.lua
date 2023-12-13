vim.g.mapleader = " "
vim.keymap.set("n", "<leader>m", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Dont ever press Q idk lol
vim.keymap.set("n", "Q", "<nop>")

-- Exit from terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n><Cmd>ToggleTerm<CR>", { silent = true})
