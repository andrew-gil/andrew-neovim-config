-- due to some manual parsing shenanigans (is_diffable_filepath), this will only work on posix filesystems (not windows)
-- note that due to hard coded context ceiling (found no viable alternative), files above 3000 lines might not show all lines
-- heavily depends on git-delta, specifically the line number output. That contract changes, this code breaks. Can do alternative solutions but would miss syntax highlighting. Would need to modify parsing to account for different text.

-- TODO, ideas for future implementation
-- jump between hunks (either using git delta syntax parsing or using git diff porcelain outputs)

local M = {}

local is_diffable_filepath = function(path)
    -- because lua does not have regex, we may struggle with this bit
    -- simplest for now will be to check that end of string is not a slash, and that string contains at least one character
    if path == nil or string.sub(path, -1) == "/" or path == '' then
        return false
    end
    return true
end

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

M.create_diff_menu_pane = function()
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
        local cur_win = vim.api.nvim_get_current_win()
        M.create_diff_menu_pane()
        --shift focus back to window
        vim.api.nvim_set_current_win(cur_win)
        M.run_diff_bat(filepath)
    end)
end

M.run_diff_bat = function(filepath)
    -- todo validate filepath is a path not directory
    local is_diffable = is_diffable_filepath(filepath)
    if is_diffable == false then
        print('WARNING: cannot run diff on a directory')
        return
    end
    -- Check if file is tracked to determine which git diff command to use
    local is_tracked = vim.fn.system({'git', 'ls-files', '--', filepath})
    local cmd

    if is_tracked == '' or is_tracked == '\n' then
        -- Untracked file
        cmd = 'git diff -U3000 --no-index /dev/null ' .. vim.fn.shellescape(filepath) .. ' | delta --line-numbers --paging=never | sed "1,7d"'
    else
        -- Tracked file
        local modified_files = vim.fn.system({'git', 'diff', 'HEAD', '--name-only', '--', filepath})
        if modified_files ~= nil and modified_files ~= '' then
            cmd = 'git diff -U3000 HEAD -- ' .. vim.fn.shellescape(filepath) .. ' | delta --line-numbers --paging=never | sed "1,7d"'
        end
    end

    if cmd == nil then
        print('WARNING: file is not modified. No diff to display')
        return
    end

    vim.cmd('normal! zz')
    local cur_buf = vim.api.nvim_get_current_buf()
    local cur_cursor_pos = vim.api.nvim_win_get_cursor(0) -- output {row, column}, 1-indexed
    local cur_line = vim.api.nvim_get_current_line()

    local term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = term_buf })
    vim.api.nvim_set_current_buf(term_buf)

    -- another closure functionality. stores last valid currentdiff line we were on while perusing the term_buf so we can jump to it when we go back.
    local last_valid_currentdiff_cursor_pos
    vim.fn.jobstart(cmd, {
        term = true,
        on_exit = function()
            vim.schedule(function()
                local diff_buf_lines = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
                for key,value in ipairs(diff_buf_lines) do
                    -- on an empty line, we look for the line number instead. Line numbers show up in git delta, will be pattern matched.
                    if string.match(value, '⋮%s+' .. cur_cursor_pos[1]) ~= nil then
                        if cur_line == '' or cur_line == nil then
                            vim.api.nvim_win_set_cursor(0, { key , #value})
                            last_valid_currentdiff_cursor_pos = { key, #value }
                        else
                            vim.api.nvim_win_set_cursor(0, { key , cur_cursor_pos[2] + (#value - #cur_line) })
                            last_valid_currentdiff_cursor_pos = { key, cur_cursor_pos[2] + (#value - #cur_line) }
                        end
                        vim.cmd('normal! zz')
                        break
                    end
                end
                vim.api.nvim_create_autocmd('CursorMoved', { buffer = term_buf, callback = function()
                    local term_buf_cur_line = vim.api.nvim_get_current_line()
                    local term_buf_cur_cursor_pos = vim.api.nvim_win_get_cursor(0)
                    local matching_line_number = string.match(term_buf_cur_line, '⋮%s+(%d+)')
                    local git_delta_linenumber_artifacts = string.match(term_buf_cur_line, '(.*│)')
                    if matching_line_number ~= nil then
                        last_valid_currentdiff_cursor_pos = { tonumber(matching_line_number), math.max(term_buf_cur_cursor_pos[2] - string.len(git_delta_linenumber_artifacts), 0) }
                    end
                end})
            end)
        end
    })

    local return_to_cur_buffer = function()
        vim.api.nvim_set_current_buf(cur_buf)
        vim.api.nvim_win_set_cursor(0, {last_valid_currentdiff_cursor_pos[1], last_valid_currentdiff_cursor_pos[2]})
        vim.cmd('normal! zz')
    end

    vim.keymap.set('n', '<Esc>', function()
        return_to_cur_buffer()
    end, { buffer = term_buf, noremap = true, silent = true })
    vim.keymap.set('n', 'q', function()
        return_to_cur_buffer()
    end, { buffer = term_buf, noremap = true, silent = true })
    vim.keymap.set('n', '<leader>dl', function()
        return_to_cur_buffer()
    end, { buffer = term_buf, noremap = true, silent = true })
end

M.setup = function()
    vim.keymap.set('n', '<leader>dm', M.create_diff_menu_pane)
    -- these come in as relative paths.
    vim.keymap.set('n', '<leader>dl', function()
        M.run_diff_bat(vim.fn.expand('%:p'))
    end)
end

return M
