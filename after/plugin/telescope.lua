local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Telescope find in git' })
vim.keymap.set('n', '<leader>gr', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>bf', builtin.buffers, { desc = 'Telescope buffer' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references,
  { noremap = true, silent = true, desc = 'Telescope LSP references' })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics,
  { desc = "Diagnostics (Telescope)" })
vim.keymap.set('n', '<leader>cs', builtin.colorscheme, { desc = 'Telescope colorscheme picker' })

require('telescope').setup {
  defaults = {
    path_display={"smart"},
    mappings = {
      i = {
        -- kill the old <C-n>/<C-p> if you want:
        ["<C-n>"] = false,
        ["<C-p>"] = false,

        -- now bind your j/k
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-d>"] = actions.delete_buffer,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
    file_ignore_patterns = {
      "node_modules"
    }
  },
  extensions = {
    ["ui-select"] = {
      -- optionally tweak the dropdown theme:
      require("telescope.themes").get_dropdown {
        previewer = false,
        -- etc…
      }
    },
  },
}
require('telescope').load_extension("ui-select")
