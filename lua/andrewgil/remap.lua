vim.g.mapleader = " "

vim.keymap.set('n', '<leader>ll', '<C-w>l', opts)
vim.keymap.set('n', '<leader>hh', '<C-w>h', opts)
vim.keymap.set('n', '<leader>kk', '<C-w>k', opts)
vim.keymap.set('n', '<leader>jj', '<C-w>j', opts)
vim.keymap.set('n', '<leader>re', vim.cmd.Ex)
vim.keymap.set('n', '<leader>[[', vim.cmd.bprev)
vim.keymap.set('n', '<leader>]]', vim.cmd.bnext)
