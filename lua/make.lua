vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.bo.makeprg = "dotnet build"
  end,
  desc = "Set dotnet compiler for C# files"
})

-- to have a quickfix workflow for dotnet test, you can do :set makeprg=dotnet test

-- Filter quickfix list to only show errors, not warnings
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "make",
  callback = function()
    -- Only filter if we're in a C# file
    if vim.bo.filetype == "cs" then
      local qflist = vim.fn.getqflist()
      local errors_only = vim.tbl_filter(function(item)
        -- Keep only errors (type 'E'), filter out warnings (type 'W')
        return item.type == 'E' or item.type == ''
      end, qflist)
      vim.fn.setqflist(errors_only, 'r')
    end
  end,
  desc = "Filter dotnet warnings from quickfix list"
})
