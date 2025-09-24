local vim = vim
local catppuccin = require("catppuccin")
catppuccin.setup({
  transparent_background = true,
  custom_highlights = function(colors)
    return {
      DiffAdd = { bg = colors.green, fg = colors.base },
      DiffRemove = { bg = colors.red, fg = colors.base }
    }
  end
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
vim.g.moonflyVirtualTextColor = true
vim.g.solarized_termtrans = 1

vim.cmd('silent! colorscheme catppuccin-mocha')
