vim.wo.relativenumber=true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop     = 2  -- literal <Tab> == 4 spaces when files are read
vim.opt.shiftwidth  = 2  -- >> << == 4 spaces
vim.opt.softtabstop = 2  -- <Tab> while typing feels like 4 spaces
vim.opt.expandtab   = true  -- convert <Tab> presses to spaces (optional)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",          -- applies to :setfiletype cs or *.cs detection
  callback = function()
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
  end,
})
