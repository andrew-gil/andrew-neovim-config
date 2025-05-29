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

require('lspconfig').ts_ls.setup {
  capabilities = caps,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
}

require('lspconfig').somesass_ls.setup {
  capabilities = caps,
  filetypes = { "scss", "sass", "css" },
  cmd = { "some-sass-language-server", "--stdio" }
}

require('lspconfig').lua_ls.setup {
  capabilities = caps,
}

require('lspconfig').angularls.setup {
  capabilities = caps,
}

local omnisharp_bin = "/Users/andrewgil/omnisharp-osx-arm64-net6/OmniSharp"
require("lspconfig").omnisharp.setup({
  cmd = {
    omnisharp_bin,
    "--languageserver",
    "--hostPID", tostring(vim.fn.getpid()),
    "-z", -- use zero‑based line/column (VS Code behaviour)
    "--encoding", "utf-8",
    "DotNet:enablePackageRestore=false",
  },
  capabilities = caps, -- the `caps` table you already created
  filetypes = { "cs" },
  settings = {         -- (optional) tweak server behaviour
    FormattingOptions = {
      EnableEditorConfigSupport = true,
    },
    Sdk = { IncludePrereleases = true },
  },
})

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

local omnisharpextended = require('omnisharp_extended')

vim.keymap.set('n', '<leader>od', omnisharpextended.lsp_definition,
  { noremap = true, silent = true, desc = 'omnisharp definition' })
vim.keymap.set('n', '<leader>ot', omnisharpextended.lsp_type_definition,
  { noremap = true, silent = true, desc = 'omnisharp type definition' })
vim.keymap.set('n', '<leader>of', omnisharpextended.lsp_references,
  { noremap = true, silent = true, desc = 'omnisharp references' })
vim.keymap.set('n', '<leader>oi', omnisharpextended.lsp_implementation,
  { noremap = true, silent = true, desc = 'omnisharp implementation' })
