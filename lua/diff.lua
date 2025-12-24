local M = {}

M.label_filepath_item = function()
    local used_labels = {}
    return function(item)
        -- Extract just the filename (everything after the last forward slash)
        local filename = item:match("([^/]+)$") or item
        local i = 1
        while i <= #filename do
            local char = string.lower(filename:sub(i, i))
            if used_labels[char] == nil then
                used_labels[char] = true
                return char
            end
            i = i + 1
        end
        -- fallback if all characters are used
        return tostring(i)
    end
end

M.get_diffed_files = function()
    -- Get modified files (unstaged changes)
    local modified = vim.fn.system({'git', 'diff', '--name-only'})
    -- Get staged files
    local staged = vim.fn.system({'git', 'diff', '--name-only', '--cached'})
    -- Get new untracked files
    local untracked = vim.fn.system({'git', 'ls-files', '-o', '--exclude-standard'})

    local mods = {}
    local seen = {}

    -- Combine all files and remove duplicates
    for match in (modified .. staged .. untracked):gmatch('[^\n]+') do
        if not seen[match] and match ~= '' then
            seen[match] = true
            table.insert(mods, match)
        end
    end
    return mods
end

M.create_diff_pane = function()
    local mods = M.get_diffed_files()
    vim.ui.select(mods, {
        prompt = 'Modified Files',
        label_item = M.label_filepath_item,
        win_predefined='hsplit'
    }, function(filename, _)
        if filename == nil then
            return
        end
        vim.cmd('e ' .. filename)
    end)
end

M.setup = function()
    vim.keymap.set('n', '<leader>dv', M.create_diff_pane)
end

return M
