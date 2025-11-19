vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    --vim.bo.makeprg = "dotnet build" -- this doesn't work lol
    vim.cmd("compiler dotnet")
  end,
  desc = "Set dotnet compiler for C# files"
})

-- TODO Filter quickfix list to only show errors, not warnings
