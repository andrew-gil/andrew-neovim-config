local vim = vim
local diffviewActions = require('diffview.actions')
require('diffview').setup({
  use_icons = false,
  keymaps = {
    view = {
      ["<CR>"] = diffviewActions.toggle_fold,
    },
  },
})

vim.keymap.set('n', '<leader>dv', function()
  local view = require('diffview.lib').get_current_view()
  if view then
    vim.cmd('DiffviewClose')
  else
    vim.cmd('DiffviewOpen')
  end
end, { desc = 'Toggle DiffView' })
