local catppuccin = require("catppuccin")
catppuccin.setup({
  transparent_background = false,
  integrations = {
    cmp         = true,
    fidget      = true,
    lsp_trouble = true,
    telescope   = true,
    which_key   = true,
    treesitter  = true,
  },
})

require("tokyonight").setup({
  transparent = false
})

require("rose-pine").setup({
  variant = 'main',
  dark_variant = 'main',
  styles = {
    transparency = false,
  }
})

vim.cmd('silent! colorscheme rose-pine-main')
vim.g.moonflyTransparent = false
vim.g.solarized_termtrans = 1
