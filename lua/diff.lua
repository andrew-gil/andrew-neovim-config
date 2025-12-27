local M = {}

-- custom labeling function, uses the first letter of the filename, while allowing the filepath to remain the item
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
    -- Get modified files
    local modified = vim.fn.system({'git', 'diff', 'HEAD', '--name-only'})
    -- Get new untracked files
    local untracked = vim.fn.system({'git', 'ls-files', '-o', '--exclude-standard'})

    local files = {}
    local seen = {}

    -- Parse the concatenated string into a table
    for match in (modified .. untracked):gmatch('[^\n]+') do
        if not seen[match] and match ~= '' then
            seen[match] = true
            table.insert(files, match)
        end
    end

    return files
end

M.create_diff_pane = function()
    local mods = M.get_diffed_files()
    vim.ui.select(mods, {
        prompt = 'Modified Files',
        label_item = M.label_filepath_item,
        win_predefined='hsplit',
    }, function(filepath, _)
        if filepath == nil then
            return
        end
        vim.cmd('e ' .. filepath)
        M.run_diff_bat(filepath)
        M.create_diff_pane()
    end)
end

M.run_diff_bat = function(filepath)
    -- Create a new fullscreen terminal buffer (like fzf#run)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

    -- Switch to the new buffer (fullscreen)
    vim.api.nvim_set_current_buf(buf)

    -- Check if file is tracked to determine which git diff command to use
    local is_tracked = vim.fn.system({'git', 'ls-files', '--', filepath})
    local cmd

    if is_tracked == '' or is_tracked == '\n' then
        -- Untracked file
        cmd = 'git diff --no-index /dev/null ' .. vim.fn.shellescape(filepath) .. ' | bat -f --style=plain'
    else
        -- Tracked file
        cmd = 'git diff -- ' .. vim.fn.shellescape(filepath) .. ' | bat -f --style=plain'
    end

    -- Start terminal
    vim.fn.termopen(cmd)

    -- Switch to normal mode after terminal loads
    vim.cmd('startinsert')
    vim.defer_fn(function()
        vim.cmd('stopinsert')
    end, 50)

    -- Set up keybindings to close with Esc or leader key
    local opts_map = { buffer = buf, noremap = true, silent = true }
    vim.keymap.set('n', '<Esc>', function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end, opts_map)
    vim.keymap.set('n', '<leader>dv', function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end, opts_map)
end

M.setup = function()
    vim.keymap.set('n', '<leader>dm', M.create_diff_pane)
    vim.keymap.set('n', '<leader>dv', function()
        M.run_diff_bat(vim.fn.expand('%:p'))
    end)
end

return M
