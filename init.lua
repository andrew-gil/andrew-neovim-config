require('andrewgil')
local vim = vim
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
-- general plugins
Plug('nvim-lua/plenary.nvim') --prereq for telescope
Plug('nvim-telescope/telescope.nvim') -- for searching and such
Plug('nvim-telescope/telescope-ui-select.nvim') -- for applying telescope ui to code actions
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- treesitter
Plug('sindrets/diffview.nvim') -- for viewing git diff
Plug('norcalli/nvim-colorizer.lua') -- for viewing hex colors while editing
-- color schemes
Plug('morhetz/gruvbox')
Plug('lifepillar/vim-solarized8')
Plug('shaunsingh/nord.nvim')
Plug('catppuccin/nvim')
Plug('folke/tokyonight.nvim')
Plug('bluz71/vim-moonfly-colors')
-- ai lol
Plug('olimorris/codecompanion.nvim')
vim.call('plug#end')
require('colorscheme')
require('lsp')
require('colorizer').setup()
require('diffview').setup()
require('codecompanion')
