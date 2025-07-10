require("codecompanion").setup({
  server = {
    type     = "ollama",
    endpoint = "http://localhost:11434",
    model    = "qwen3:8b",
    stream   = true,
    format   = "json",
    options  = { num_predict = 512, temperature = 0.2 },
  },
  strategies = {
    chat   = { adapter = "ollama" },
    inline = { adapter = "ollama" },
    cmd    = { adapter = "ollama" },
  },
  presets = {
    chat = {
      max_output_tokens = 800,
      context           = "auto",
    },
  },
})

vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
