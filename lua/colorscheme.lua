require("catppuccin").setup({
  transparent_background = false,
  integrations = {
    cmp         = true,
    fidget      = true,
    lsp_trouble = true,
    telescope   = true,
    which_key   = true,
  },
})
vim.cmd('silent! colorscheme catppuccin')
