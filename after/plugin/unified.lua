local unified = require('unified')
unified.setup()

vim.keymap.set('n', '<leader>uv', function()
    unified.toggle()
end, { desc = 'Toggle Unified Diff View' })

vim.keymap.set('n', '<leader>uc', function()
    vim.cmd('Unified reset')
end, { desc = 'Clear diff markings from current buffer.' })
