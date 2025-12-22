-- can we deprectate fzf lua? it is a fairly heavy plugin that I don't fully use, and I don't fully like the fuzzy searching workflow
-- I prefer to use native vim stuff if possible. Let's say I can spin up my own vim.ui.select. then,
local fzf = require('fzf-lua')
fzf.setup({
  keymap = {
    fzf = {
      ["alt-a"]         = "select-all+accept",
    }
  }
})

-- can replace with custom findexpr function use fd, pipe results out to custom vim.ui.select
vim.keymap.set('n', '<leader><leader>', fzf.files)
-- can replace with custom findexpr function? look at buffers, use fd, pipe results out to custom vim.ui.select
vim.keymap.set('n', '<leader>bf', fzf.buffers)
vim.keymap.set('n', '<leader>gs', fzf.git_status)
vim.keymap.set('n', '<leader>gh', fzf.git_diff)

-- fzf grep stuff.
vim.keymap.set('n', '<leader>gr', fzf.grep)
vim.keymap.set('n', '<leader>ga', ":lua FzfLua.grep({resume=true})<cr>")
vim.keymap.set('v', '<leader>8', fzf.grep_visual)
vim.keymap.set('n', '<leader>gl', fzf.live_grep)

-- fzf lsp stuff. Generally, if I could benefit from the preview or the search, it's worth using this over vim.lsp.buf.
-- add outgoing_calls and incoming_calls ; generally subsets of find references, but can be helpful
vim.keymap.set('n', '<leader>fr', fzf.lsp_references,
  { noremap = true, silent = true, desc = 'LSP references' })
vim.keymap.set('n', '<leader>gi', fzf.lsp_implementations,
  { noremap = true, silent = true })
vim.keymap.set("n", "<leader>db", fzf.diagnostics_document)
vim.keymap.set("n", "<leader>dw", fzf.diagnostics_workspace)

-- fzf nice to haves
vim.keymap.set('n', '<leader>cs', fzf.colorschemes)
vim.keymap.set('n', '<leader>co', fzf.quickfix)
