vim.g.mapleader = " "

vim.keymap.set('n', '<leader>wl', '<C-w>l')
vim.keymap.set('n', '<leader>wh', '<C-w>h')
vim.keymap.set('n', '<leader>wk', '<C-w>k')
vim.keymap.set('n', '<leader>wj', '<C-w>j')
vim.keymap.set('n', '<leader>w0', '<C-w>=')
vim.keymap.set('n', '<leader>w-', '12<C-w><')
vim.keymap.set('n', '<leader>w=', '12<C-w>>')
vim.keymap.set('n', '<leader>re', vim.cmd.Ex)
vim.keymap.set('n', '<leader>[[', vim.cmd.bprev)
vim.keymap.set('n', '<leader>]]', vim.cmd.bnext)
vim.keymap.set('n', '<leader><Tab>', '<C-6>')
--reevaluate how much I like these. I generally don't like hiding functionality that's not obviously an abstraction, and could be misinterpreted as the actual functionality
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
