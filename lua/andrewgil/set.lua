local vim = vim
vim.wo.relativenumber = true
vim.opt.clipboard     = "unnamedplus"
vim.opt.tabstop       = 4  -- literal <Tab> == 4 spaces when files are read
vim.opt.shiftwidth    = 4  -- >> << == 4 spaces
vim.opt.softtabstop   = 4  -- <Tab> while typing feels like 4 spaces
vim.opt.expandtab     = true -- convert <Tab> presses to spaces (optional)
vim.opt.background    = "dark"
vim.opt.termguicolors = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
--function UseFd(fname)
--  local results = vim.fn.systemlist('fd --type f --hidden --exclude .git ' .. vim.fn.shellescape(fname))
--  return table.concat(results, '\n')
--end
--vim.o.findexpr="v:lua.UseFd(v:fname)"


vim.keymap.set('n', '<leader>do', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.keymap.set('n', '<leader>de', function()
  local current_config = vim.diagnostic.config()
  if current_config.virtual_lines then
    vim.diagnostic.config({ virtual_text = { current_line = true }, virtual_lines = false })
  else
    vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true, wrap = true } })
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
      vim.diagnostic.config({ virtual_text = false, virtual_lines = { wrap = true } })
    else
      vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true, wrap = true } })
    end
  end
end, { silent = true, noremap = true })

vim.keymap.set('n', '<leader>dd', function() vim.diagnostic.open_float() end, { silent = true, noremap = true })
