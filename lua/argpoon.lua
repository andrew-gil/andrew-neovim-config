--homemade harpoon, plus status line changes

vim.keymap.set('n', '<leader>hh', function()
    vim.cmd(vim.fn.argc().."argadd %")
    vim.cmd("argdedup")
    vim.cmd("redrawstatus")
    vim.cmd('silent! '..vim.fn.argc()..'argument')
end)

vim.keymap.set('n', '<leader>hd', function()
    vim.cmd("argdelete %")
end)

-- todo display the output into a floating buffer like codecompanion does. Just order it. Parse the output such that only file names are displayed, not paths. Unless, their are duplicate file names with different paths; then display the full path.
vim.keymap.set('n', '<leader>hl', function()
    vim.cmd.args()
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
