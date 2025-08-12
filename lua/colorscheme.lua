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
  transparent = true
})

require("rose-pine").setup({
  variant = 'main',
  dark_variant = 'main',
  styles = {
    transparency = false,
  }
})

vim.cmd('silent! colorscheme tokyonight-night')
vim.g.moonflyTransparent = true
vim.g.solarized_termtrans = 1
