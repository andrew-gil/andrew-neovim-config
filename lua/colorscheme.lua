require("catppuccin").setup({
  transparent_background = true,
  integrations = {
    cmp         = true,
    fidget      = true,
    lsp_trouble = true,
    telescope   = true,
    which_key   = true,
  },
})
vim.cmd('silent! colorscheme catppuccin-mocha')
