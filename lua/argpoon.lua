--homemade harpoon, requires statusline.lua for full functionality

vim.keymap.set('n', '<leader>hh', function()
    vim.cmd(vim.fn.argc().."argadd %")
    vim.cmd("argdedup")
    vim.cmd("redrawstatus")
    vim.cmd('silent! '..vim.fn.argc()..'argument')
end)

vim.keymap.set('n', '<leader>hd', function()
    vim.cmd("argdelete %")
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
        prompt = 'Jump To Argpooned Buffer:',
		format_item = function(item)
			for index, value in ipairs(args) do
				if value == item then
					local i = #value
					while i > 0 and string.sub(value, i, i) ~= "/" do
						i = i-1
					end
					if value == cur_bufname then
						return "["..index.."]: " .. string.sub(value, i+1)
					end
					return " " .. index .. " : " .. string.sub(value, i+1)
				end
			end
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
