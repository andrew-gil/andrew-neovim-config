require('andrewgil')
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
--Plug('OmniSharp/omnisharp-vim')
-- Language Servers
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/vim-vsnip')
Plug('hrsh7th/cmp-vsnip')
--Plug('mason-org/mason.nvim')
--Plug('mason-org/mason-lspconfig.nvim')
Plug('norcalli/nvim-colorizer.lua')
Plug('sindrets/diffview.nvim')
-- general plugins
Plug('nvim-lua/plenary.nvim') --prereq for telescope
Plug('nvim-telescope/telescope.nvim') -- for searching and such
Plug('nvim-telescope/telescope-ui-select.nvim') -- for applying telescope ui to code actions
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- treesitter
-- color schemes
Plug('morhetz/gruvbox')
Plug('lifepillar/vim-solarized8')
Plug('shaunsingh/nord.nvim')
Plug('catppuccin/nvim')
vim.call('plug#end')
require('colorscheme')
require('lsp')
require('colorizer').setup()
require('diffview').setup()
