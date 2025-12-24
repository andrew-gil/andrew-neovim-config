local M = {}

-- Factory function that creates a label_item function with its own used_labels state
-- Returns a function that extracts a unique single-character label from each item
M.label_item_default = function(format_item)
    local used_labels = {}
    return function(item)
        local formatted = format_item(item)
        local i = 1
        while i <= #formatted do
            local char = string.lower(formatted:sub(i, i))
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

M.get_opts = function(win_predefined, prompt, height)
    -- creating buffer ui
    local width = math.min(90, vim.o.columns - 4)

    local center_win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' ' .. (prompt or 'Select item') .. ' ',
        title_pos = 'center',
    }

    local bottom_win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height - 2)),  -- -2 for border
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' ' .. (prompt or 'Select item') .. ' ',
        title_pos = 'center',
    }

    local hsplit_win_opts = {
        split = 'below',
        win = 0,
        height = height,
    }

    if win_predefined == 'bottom' then
        return bottom_win_opts
    elseif win_predefined == 'hsplit' then
        return hsplit_win_opts
    else
        return center_win_opts
    end
end

--opts: 
--(standard) prompt: title
--(standard) kind: arbitrary hint string
--(standard) format_item: for the line to display 
--label_item (not standard) which is a custom thing I can pass in to define what's shown and the shortcut. it should be one character.
--win_opts, so the caller can decide where they want their window to go
--win_predefined can be "center" "bottom" "hsplit"
M.ui_select = function(items, opts, on_choice)
    -- Validate inputs
    if not items or #items == 0 then
        print('ERROR: ui_select called with empty or nil items')
        return
    end
    if not opts then
        print('ERROR: ui_select called with nil opts')
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    -- wipe leaves no cache, as opposed to delete. bufhidden is when we click escape or :q  
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

    -- creating buffer content
    local format_item = opts.format_item or tostring
    -- use letters of the line as my labels
    -- opts.label_item should be a factory function that returns a label function
    local label_item_factory = opts.label_item or function() return M.label_item_default(format_item) end
    local label_item = label_item_factory()

    local lines = {}
    for i, item in ipairs(items) do
        lines[i] =  '    ' .. label_item(item) .. ': '.. format_item(item) .. '    '
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- add green highlighting to labels
    local ns_id = vim.api.nvim_create_namespace('ui_select_labels')
    for i, line in ipairs(lines) do
        local label_end = line:find(': ')
        if label_end then
            vim.api.nvim_buf_add_highlight(buf, ns_id, 'String', i - 1, 0, label_end - 1)
        end
    end

    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })


    local win_opts = M.get_opts(opts.win_predefined, opts.prompt, #lines)

    local win = vim.api.nvim_open_win(buf, true, opts.win_opts or win_opts)
    vim.api.nvim_set_option_value('cursorline', true, { win = win })

    -- track current selection
    local current_line = 1

    -- helper to close window and cleanup
    local function close_and_choose(selected_idx)
        vim.api.nvim_win_close(win, true)
        if selected_idx then
            on_choice(items[selected_idx], selected_idx)
        else
            on_choice(nil, nil)
        end
    end

    -- keymaps - opts_map tells us that these only apply on my custom buffer
    local opts_map = { noremap = true, silent = true, buffer = buf }

    -- handle selection
    vim.keymap.set('n', '<CR>', function()
        current_line = vim.api.nvim_win_get_cursor(win)[1]
        close_and_choose(current_line)
    end, opts_map)

    local function wrap(func, a, b)
        return function()
            func(a, b)
        end
    end

    local function go_to_item(item, selected_idx)
        vim.api.nvim_win_close(win, true)
        on_choice(item, selected_idx)
    end

    -- Reset label generation for keybinding creation
    label_item = label_item_factory()
    for idx,item in ipairs(items) do
        local label = label_item(item)
        if #label > 1 then
            print('WARNING: keybinds wll not work if label is longer than one character')
        elseif label == 'j' or label == 'k' or label == '<Esc>' or label == '<CR>' then
            print('WARNING: cannot use reserved keys (j, k, Esc, CR) as label. keybind not set.')
        else
            vim.keymap.set('n', ''..label, wrap(go_to_item, item, idx), opts_map)
        end
    end

    -- cancel
    vim.keymap.set('n', '<Esc>', function() close_and_choose(nil) end, opts_map)

    -- navigation
    vim.keymap.set('n', 'j', 'j', opts_map)
    vim.keymap.set('n', 'k', 'k', opts_map)
end

-- Setup function to override vim.ui.select
function M.setup()
    vim.ui.select = M.ui_select
end

return M
