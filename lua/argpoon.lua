--homemade harpoon, requires statusline.lua for full functionality

local function get_args()
	local args = {}
    for i = 0,vim.fn.argc()-1 do
		args[i+1] = vim.fn.argv(i)
    end
    return args
end

vim.keymap.set('n', '<leader>hh', function()
    vim.cmd(vim.fn.argc().."argadd %")
    vim.cmd("argdedup")
    vim.cmd("redrawstatus")
    vim.cmd('silent! '..vim.fn.argc()..'argument')
end)

vim.keymap.set('n', '<leader>hd', function()
    vim.cmd("argdelete %")
    vim.cmd("redrawstatus")
end)

vim.keymap.set('n', '<leader>hs', function()
    -- argpoon menu. Shows buffers, gives keybinds to get to buffers.
	local cur_bufname = vim.fn.bufname()
    local args = get_args()

    local function index_to_label(i)
        if i < 10 or i > 35 then
            return tostring(i)
        else
            return string.char(string.byte('a') + i - 10)
        end
    end

    if #args > 0 then
        vim.ui.select(args, {
            prompt = 'Select Argpooned Buffer',
            format_item = function(item)
                if item == cur_bufname then
                    return "[" .. item .. "]"
                end
                return item
            end,
            label_item = function(item)
                -- Find the index of this item
                local idx = nil
                for i, arg in ipairs(args) do
                    if arg == item then
                        idx = i
                        break
                    end
                end
                if idx == nil then
                    -- arbitrary key to indicate that something went wrong
                    return '?'
                end
                return index_to_label(idx)
            end,
            win_predefined='center'
        }, function(_, index)
            if index ~= nil then
                vim.cmd('silent! '..(index)..'argument')
            end
        end)
    else
        print('Warning: no arguments to display')
    end
end)


-- works via closure, design pattern to be able to assign keymaps in a loop
local function wrap(func, i)
    return function()
        func(i)
    end
end

local function n_arg(n)
    vim.cmd('silent! '..n..'argument')
end

local function move_to_arg(n)
	local cur_bufname = vim.fn.bufname()
    local args = get_args()
    local curBufArgIdx = nil

    if n < 1 or n > vim.fn.argc() then
        print('ERROR: target position must be between 1 and ' .. vim.fn.argc())
        return
    end

    for idx, item in ipairs(args) do
        if item == cur_bufname then
            curBufArgIdx = idx
            break
        end
    end

    if curBufArgIdx == nil then
        print('ERROR current buffer is not an argument')
        return
    end

    if curBufArgIdx == n then
        print('WARNING target argument index is the same as current buffer index. Will execute no operation')
        return
    end

    vim.cmd('argdelete ' .. vim.fn.fnameescape(cur_bufname))

    -- argadd with count N adds after position N, so for position n we use n-1
    local insert_pos = n - 1
    vim.cmd(insert_pos .. 'argadd ' .. vim.fn.fnameescape(cur_bufname))

    vim.cmd("redrawstatus")
end

for i = 1,35 do
    if i < 10 then
        vim.keymap.set('n', '<leader>h'..i, wrap(n_arg, i))
        vim.keymap.set('n', '<C-h>'..i, wrap(move_to_arg, i))
    else
        vim.keymap.set('n', '<C-h>'..string.char(string.byte('a') + i - 10), wrap(move_to_arg, i))
        -- not setting keybinds for the letters. If we want to nav to a letter, use argpoon menu
    end
end

-- Save and restore argument list (directory-specific)
local history_file = vim.fn.expand('~/.local/share/nvim/argpoon_history.json')

local function load_history()
    local file = io.open(history_file, 'r')
    if not file then
        return vim.empty_dict()
    end

    local content = file:read('*all')
    file:close()

    if content == '' then
        return vim.empty_dict()
    end

    local ok, history = pcall(vim.fn.json_decode, content)
    if not ok then
        print('Warning: Could not parse history file, starting fresh')
        return vim.empty_dict()
    end

    return history
end

local function save_history(history)
    -- Ensure directory exists
    local dir = vim.fn.fnamemodify(history_file, ':h')
    if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
    end

    local file = io.open(history_file, 'w')
    if not file then
        print('Error: Could not open ' .. history_file)
        return false
    end

    file:write(vim.fn.json_encode(history))
    file:close()
    return true
end

local function save_args()
    local cwd = vim.fn.getcwd()
    local args = {}
    for i = 0, vim.fn.argc() - 1 do
        table.insert(args, vim.fn.argv(i))
    end

    -- Load existing history
    local history = load_history()

    -- Update entry for current directory
    history[cwd] = args

    -- Save history
    if save_history(history) then
        print('Saved ' .. #args .. ' arguments for ' .. cwd)
    end
end

local function restore_args()
    local cwd = vim.fn.getcwd()
    local history = load_history()

    local args = history[cwd]
    if not args or #args == 0 then
        print('No saved arguments found for ' .. cwd)
        return
    end

    -- Build escaped argument list
    local escaped_args = {}
    for _, arg in ipairs(args) do
        table.insert(escaped_args, vim.fn.fnameescape(arg))
    end

    -- Use :args to set all arguments at once (preserves order)
    vim.cmd('args ' .. table.concat(escaped_args, ' '))

    print('Restored ' .. #args .. ' arguments for ' .. cwd)
    vim.cmd('redrawstatus')
end

vim.api.nvim_create_user_command('ArgStash', save_args, {
    desc = 'Save current argument list to history file'
})

vim.api.nvim_create_user_command('ArgRestore', restore_args, {
    desc = 'Restore argument list from history file'
})

-- Short aliases
vim.api.nvim_create_user_command('ArgS', save_args, {
    desc = 'Save current argument list to history file (alias for ArgStash)'
})

vim.api.nvim_create_user_command('ArgR', restore_args, {
    desc = 'Restore argument list from history file (alias for ArgRestore)'
})


