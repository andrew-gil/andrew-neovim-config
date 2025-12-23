require('andrewgil')
local Plug = vim.fn['plug#']

vim.call('plug#begin')
-- Language Server related plugins
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/vim-vsnip')
Plug('hrsh7th/cmp-vsnip')
Plug('https://github.com/Hoffs/omnisharp-extended-lsp.nvim.git')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
-- searching
Plug('ibhagwan/fzf-lua')
-- nice to haves
-- currently flagging because it is using tbl_flatten, which will be deprecated in nvim 13
Plug('norcalli/nvim-colorizer.lua') -- for viewing hex colors while editing
Plug('fabijanzulj/blame.nvim')
-- color schemes
Plug('morhetz/gruvbox')
Plug('lifepillar/vim-solarized8')
Plug('shaunsingh/nord.nvim')
Plug('catppuccin/nvim')
Plug('folke/tokyonight.nvim')
Plug('bluz71/vim-moonfly-colors')
Plug('rose-pine/neovim', {['as'] = 'rose-pine'})

vim.call('plug#end')

require('statusline')
require('colorscheme')
require('searching')
require('lsp')
require('make')
require('blametoggle')
require('fzf').setup_fzf()

require('colorizer').setup()
require('vimuiselect').setup()
require('vim._extui').enable({})
