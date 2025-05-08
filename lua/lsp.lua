local cmp = require('cmp')

cmp.setup({
   snippet = {
      expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
      end,
   },
   mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = function(fallback)
      if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end
   },
   sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
   }
})

-- Setup lspconfig.
require('lspconfig').ts_ls.setup {
   capabilities = require('cmp_nvim_lsp').default_capabilities()
}

require('lspconfig').somesass_ls.setup {
	capabilities = require('cmp_nvim_lsp').default_capabilities()
}	

vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,
  { noremap = true, silent = true, desc = 'LSP definition'} )
vim.keymap.set('n', '<leader>hv', vim.lsp.buf.hover,
  { noremap = true, silent = true, desc = 'LSP hover'} )
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
  { noremap = true, silent = true, desc = 'LSP code action'} )
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = 'LSP rename'} )
