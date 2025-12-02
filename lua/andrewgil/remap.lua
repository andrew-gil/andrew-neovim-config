vim.g.mapleader = " "

vim.keymap.set('n', '<leader>wl', '<C-w>l')
vim.keymap.set('n', '<leader>wh', '<C-w>h')
vim.keymap.set('n', '<leader>wk', '<C-w>k')
vim.keymap.set('n', '<leader>wj', '<C-w>j')
vim.keymap.set('n', '<leader>w0', '<C-w>=')
vim.keymap.set('n', '<leader>w-', '12<C-w><')
vim.keymap.set('n', '<leader>w=', '12<C-w>>')
vim.keymap.set('n', '<leader>re', vim.cmd.Ex)
--reevaluate how much I like these. I generally don't like hiding functionality that's not obviously an abstraction, and could be misinterpreted as the actual functionality
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<C-d>", "<C-d>zz")

vim.keymap.set('n', "<leader>cn", vim.cmd.cnext)
vim.keymap.set('n', "<leader>cp", vim.cmd.cprev)

-- CLI command legend
vim.keymap.set('n', '<leader>cl', function() require('legend').toggle_legend() end,
  { desc = 'Toggle CLI legend' })
