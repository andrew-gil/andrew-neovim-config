vim.wo.relativenumber = true
vim.opt.clipboard     = "unnamedplus"
vim.opt.tabstop       = 2  -- literal <Tab> == 4 spaces when files are read
vim.opt.shiftwidth    = 2  -- >> << == 4 spaces
vim.opt.softtabstop   = 2  -- <Tab> while typing feels like 4 spaces
vim.opt.expandtab     = true -- convert <Tab> presses to spaces (optional)
vim.opt.background    = "dark"
vim.opt.termguicolors = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs", -- applies to :setfiletype cs or *.cs detection
  callback = function()
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })

vim.keymap.set('n', '<leader>do', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.keymap.set('n', '<leader>dd', function()
  local current_config = vim.diagnostic.config()
  if current_config.virtual_lines then
    vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
  else
    vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
  end
end, { silent = true, noremap = true })

vim.keymap.set('n', '<leader>da', function()
  local current_config = vim.diagnostic.config()
  if current_config.virtual_text then
    if type(current_config.virtual_text) == "table" and current_config.virtual_text.current_line then
      vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
    else
      vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
    end
  elseif current_config.virtual_lines then
    if type(current_config.virtual_lines) == "table" and current_config.virtual_lines.current_line then
      vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
    else
      vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
    end
  end
end, { silent = true, noremap = true })
