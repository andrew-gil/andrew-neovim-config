-- file search --
function UseFd(cmdarg, cmdcomplete)
    local all_files = vim.fn.systemlist('fd --type f --hidden --exclude .git --exclude node_modules')

    -- Filter files that match the cmdarg pattern
    local matches = vim.tbl_filter(function(file)
        return string.find(file:lower(), cmdarg:lower(), 1, true) ~= nil
    end, all_files)

    return matches
end

vim.o.findfunc = 'v:lua.UseFd'

-- git status search --
function UseGitStatus(cmdarg, _)
    -- Get modified, untracked, and staged files from git status
    local git_files = vim.fn.systemlist('git status --short --porcelain')

    -- Parse git status output (format: "XY filename")
    -- X = staged status, Y = unstaged status
    local files = {}
    for _, line in ipairs(git_files) do
        -- Extract filename (skip first 3 characters which are status indicators)
        local filename = line:sub(4)
        table.insert(files, filename)
    end

    -- Filter files that match the cmdarg pattern
    local matches = vim.tbl_filter(function(file)
        return string.find(file:lower(), cmdarg:lower(), 1, true) ~= nil
    end, files)

    return matches
end

vim.api.nvim_create_user_command('GitStatus', function(opts)
    local original_findfunc = vim.o.findfunc
    vim.o.findfunc = 'v:lua.UseGitStatus'
    vim.cmd('find ' .. opts.args)
    vim.o.findfunc = original_findfunc
end, {
    nargs = 1,
    complete = function(arg_lead, cmd_line, cursor_pos)
        return UseGitStatus(arg_lead, true)
    end
})
vim.cmd([[cabbrev gs GitStatus]])

-- Custom Find command with vim.ui.select for multiple results --
vim.api.nvim_create_user_command('Find', function(opts)
    local pattern = opts.args

    -- Get results from fd
    local results = vim.fn.systemlist('fd --type f --hidden --exclude .git --exclude node_modules ' .. vim.fn.shellescape(pattern))

    if #results == 0 then
        print('No files found matching: ' .. pattern)
    elseif #results == 1 then
        -- Single result: open directly
        vim.cmd('edit ' .. vim.fn.fnameescape(results[1]))
    else
        -- Multiple results: use vim.ui.select
        vim.ui.select(results, {
            prompt = 'Select file (' .. #results .. ' matches):',
            format_item = function(item)
                return item
            end,
        }, function(choice)
            if choice then
                vim.cmd('edit ' .. vim.fn.fnameescape(choice))
            end
        end)
    end
end, {
    nargs = 1,
    complete = function(arg_lead)
        return vim.fn.systemlist('fd --type f --hidden --exclude .git --exclude node_modules ' .. vim.fn.shellescape(arg_lead))
    end
})

-- grep --
vim.opt.grepprg = 'rg --vimgrep --smart-case --hidden'
vim.cmd([[cabbrev rg grep]])
