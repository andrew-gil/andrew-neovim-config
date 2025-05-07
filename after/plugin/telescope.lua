local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find in git'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        -- kill the old <C-n>/<C-p> if you want:
        ["<C-n>"] = false,
        ["<C-p>"] = false,

        -- now bind your j/k
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
}
