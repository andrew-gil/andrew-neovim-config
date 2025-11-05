local fzf = require('fzf-lua')
fzf.setup()

vim.keymap.set('n', '<leader><leader>', fzf.files)
vim.keymap.set('n', '<leader>gs', fzf.git_status)
vim.keymap.set('n', '<leader>gr', fzf.live_grep)
vim.keymap.set('n', '<leader>bf', fzf.buffers)
vim.keymap.set('n', '<leader>fr', fzf.lsp_references,
  { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fi', fzf.lsp_implementations,
  { noremap = true, silent = true })
vim.keymap.set("n", "<leader>db", fzf.diagnostics_document)
vim.keymap.set("n", "<leader>dw", fzf.diagnostics_workspace)
vim.keymap.set('n', '<leader>cs', fzf.colorschemes)
fzf.register_ui_select()
