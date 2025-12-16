require('argpoon')
local cmp = {} -- statusline components

function _G._statusline_component(name)
    return cmp[name]()
end

local hi_pattern = '%%#%s#%s%%*'

function cmp.diagnostic_status()
    local ignore = {
        ['c'] = true, -- command mode
        ['t'] = true  -- terminal mode
    }

    local mode = vim.api.nvim_get_mode().mode

    if ignore[mode] then
        return ''
    end

    local levels = vim.diagnostic.severity
    local errors = #vim.diagnostic.get(0, {severity = levels.ERROR})
    if errors > 0 then
        return hi_pattern:format('DiagnosticError', errors ..'  ')
    end

    local warnings = #vim.diagnostic.get(0, {severity = levels.WARN})
    if warnings > 0 then
        return hi_pattern:format('DiagnosticWarn', warnings ..'  ')
    end

    return hi_pattern:format('DiagnosticOk', '  ')
end

function cmp.line_position()
    return hi_pattern:format('Search', ' %3l:%-3c ')
end

function cmp.harpoon()
    -- if in arg list, return the arg number. Else, return something else
    for i = 0,vim.fn.argc()-1 do
        if (vim.fn.argv(i) == vim.fn.bufname()) then
            -- need to increment all i's + 1 to match argpon 1 indexing
            if i < 9 or i > 34 then
                return hi_pattern:format('Special', ' 󰣉 ' .. i + 1 .. ' ')
            else
                return hi_pattern:format('Special', ' 󰣉 ' .. string.char(string.byte('a') + i - 9) .. ' ')
            end
        end
    end
    return hi_pattern:format('Type', ' 󱡁 ~ ')
end



-- do %t for "tail end of file" (eg. file name), but %f if file path matters (eg. duplicate file names because bad repositories lol)
local statusline = {
    '%{%v:lua._statusline_component("harpoon")%}',
    '%t',
    '%r',
    '%m',
    '%=',
    '%{%v:lua._statusline_component("diagnostic_status")%} ',
    '%{&filetype} ',
    ' %2p%% ',
    '%{%v:lua._statusline_component("line_position")%}'
}

vim.o.statusline = table.concat(statusline, '')
