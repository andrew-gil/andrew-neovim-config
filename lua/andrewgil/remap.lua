vim.g.mapleader = " "

vim.keymap.set('n', '<leader>wl', '<C-w>l', opts)
vim.keymap.set('n', '<leader>wh', '<C-w>h', opts)
vim.keymap.set('n', '<leader>wk', '<C-w>k', opts)
vim.keymap.set('n', '<leader>wj', '<C-w>j', opts)
vim.keymap.set('n', '<leader>w0', '<C-w>=', opts)
vim.keymap.set('n', '<leader>w-', '12<C-w><', opts)
vim.keymap.set('n', '<leader>w=', '12<C-w>>', opts)
vim.keymap.set('n', '<leader>re', vim.cmd.Ex)
vim.keymap.set('n', '<leader>[[', vim.cmd.bprev)
vim.keymap.set('n', '<leader>]]', vim.cmd.bnext)
