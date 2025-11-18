--homemade harpoon, requires statusline.lua for full functionality

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

vim.keymap.set('n', '<leader>hl', function()
    vim.cmd.args()
end)

vim.keymap.set('n', '<leader>hs', function()
	local cur_bufname = vim.fn.bufname()
	local args = {}
    for i = 0,vim.fn.argc()-1 do
		args[i+1] = vim.fn.argv(i)
    end
    vim.ui.select(args, {
        prompt = 'Jump To Argpooned Buffer: ',
		format_item = function(item)
            if item == cur_bufname then
                return "[" .. item .. "]"
            end
			--for index, value in ipairs(args) do
			--	if value == item then
			--		local i = #value
			--		while i > 0 and string.sub(value, i, i) ~= "/" do
			--			i = i-1
			--		end
			--		if value == cur_bufname then
			--			return "["..index.."]: " .. string.sub(value, i+1)
			--		end
			--		return " " .. index .. " : " .. string.sub(value, i+1)
			--	end
			--end
			return item
		end
    }, function(_, index)
		if index ~= nil then
			vim.cmd('silent! '..(index)..'argument')
		end
    end)
end)

-- todo write a function that allows me to switch the position of an argument. For example, 7 goes to 2, 2 goes to 3, everything moves up

-- works via closure
local function wrap(func, i)
    return function()
        func(i)
    end
end

local function nArg(n)
    vim.cmd('silent! '..n..'argument')
end

for i = 1,9 do
    vim.keymap.set('n', '<leader>h'..i, wrap(nArg, i))
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
