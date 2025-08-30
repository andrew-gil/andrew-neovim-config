local vim = vim
local catppuccin = require("catppuccin")
catppuccin.setup({
  transparent_background = true,
})

require("tokyonight").setup({
  transparent = true
})

require("rose-pine").setup({
  variant = 'main',
  dark_variant = 'main',
  styles = {
    transparency = false,
  }
})

vim.g.moonflyTransparent = true
vim.g.solarized_termtrans = 1

vim.cmd('silent! colorscheme rose-pine-main')
