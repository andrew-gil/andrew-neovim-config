require('blame').setup();

vim.keymap.set('n', "<leader>bt", ":BlameToggle<cr>", { noremap = true, silent = true });
