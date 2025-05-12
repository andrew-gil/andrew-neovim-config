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

local caps = require('cmp_nvim_lsp').default_capabilities()
require('mason').setup()
--require('mason-lspconfig').setup()

require('lspconfig').ts_ls.setup {
  capabilities = caps,
}

require('lspconfig').somesass_ls.setup {
  capabilities = caps,
  filetypes = { "scss", "sass", "css" },
  cmd = { "some-sass-language-server", "--stdio" }
}

require('lspconfig').lua_ls.setup {
  capabilities = caps,
}

--require('lspconfig').omnisharp.setup {
--  capabilities                = caps,
--
--  -- point to the binary if it’s on your PATH (Mason, vim‑plug, or dotnet‑tool)
--  -- If you used `dotnet tool install -g omnisharp`: just `"omnisharp"`
--  -- If Mason: vim.fn.stdpath('data') .. '/mason/bin/omnisharp'
--  cmd                         = { vim.fn.expand("~/.cache/omnisharp-vim/omnisharp-roslyn/run"), "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
--
--  -- optional: enable Roslyn analyzers, etc.
--  enable_editorconfig_support = true,
--  enable_import_completion    = true,
--  organize_imports_on_format  = true,
--}

vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,
  { noremap = true, silent = true, desc = 'LSP definition' })
vim.keymap.set('n', '<leader>hv', vim.lsp.buf.hover,
  { noremap = true, silent = true, desc = 'LSP hover' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
  { noremap = true, silent = true, desc = 'LSP code action' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = 'LSP rename' })
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format,
  { noremap = true, silent = true, desc = 'LSP format' })
