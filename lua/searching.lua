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

-- grep --
vim.opt.grepprg = 'rg --vimgrep --smart-case --hidden'
vim.cmd([[cabbrev rg grep]])
