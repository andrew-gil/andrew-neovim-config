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

vim.lsp.config['ts_ls'] = {
  capabilities = caps,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
}

vim.lsp.enable({'ts_ls'})

vim.lsp.config['somesass_ls'] = {
  capabilities = caps,
  filetypes = { "scss", "sass", "css" },
  cmd = { "some-sass-language-server", "--stdio" }
}

vim.lsp.enable({'somesass_ls'})

vim.lsp.config['lua_ls'] = {
  capabilities = caps,
}

vim.lsp.enable({'lua_ls'})

vim.lsp.config['angularls'] = {
  capabilities = caps,
}

vim.lsp.enable({'angularls'})

local omnisharp_bin = "/usr/bin/omnisharp"
vim.lsp.config['omnisharp'] = {
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
    RoslynExtensionsOptions = {
        EnableDecompilationSupport = true
    }
  },
}

vim.lsp.enable({'omnisharp'})

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

-- Stop LSP client for current buffer
local function stop_buffer_lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
    return
  end

  vim.ui.select(clients, {
    prompt = "Stop LSP Client:",
    format_item = function(client)
      return string.format("[%d] %s", client.id, client.name)
    end,
  }, function(client)
    if client then
      vim.lsp.stop_client(client.id)
      vim.notify(string.format("Stopped LSP client: %s. save buffer to see this reflected. :e to reverse.", client.name), vim.log.levels.INFO)
    end
  end)
end

vim.keymap.set('n', '<leader>ls', stop_buffer_lsp,
  { noremap = true, silent = true, desc = 'Stop LSP for buffer' })
