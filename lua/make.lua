vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.bo.makeprg = "dotnet build"
  end,
  desc = "Set dotnet compiler for C# files"
})

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

-- Run dotnet test and populate quickfix with failures
local function dotnet_test()
  -- Save the errorformat
  local saved_efm = vim.o.errorformat

  -- Set errorformat for dotnet test output
  -- Format: "  at Namespace.Class.Method() in /path/file.cs:line 123"
  vim.o.errorformat = '%E%*[\\ ]at%.%#in %f:line %l,%Z%*[\\ ]%m,%C%m,%-G%.%#'

  -- Run dotnet test and capture output
  vim.cmd('cexpr system("dotnet test 2>&1")')

  -- Restore errorformat
  vim.o.errorformat = saved_efm

  -- Open quickfix window
  vim.cmd('copen')
end

-- Create command for running dotnet test
vim.api.nvim_create_user_command('DotnetTest', dotnet_test, {
  desc = 'Run dotnet test and populate quickfix with failures'
})

-- Optionally set makeprg for test in C# files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    -- You can use :make! (with bang) to run tests instead of build
    -- vim.bo.makeprg = 'dotnet test'
  end,
  desc = "Configure dotnet test for C# files"
})
